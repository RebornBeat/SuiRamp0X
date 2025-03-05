module suiramp::p2p_trading {
    use std::string::{Self, String};
    use std::vector;
    use sui::object::{Self, ID, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};
    use sui::event;
    use sui::clock::{Self, Clock};
    use std::option::{Self, Option};
    use sui::table::{Self, Table};

    // Error codes
    const ENO_ORDER_MATCH: u64 = 0;
    const EINVALID_AMOUNT: u64 = 1;
    const EORDER_ALREADY_MATCHED: u64 = 2;
    const EINVALID_ORDER_STATUS: u64 = 3;
    const EINVALID_PAIR: u64 = 4;
    const EINVALID_PRICE: u64 = 5;
    const EINVALID_ESCROW: u64 = 6;
    const EUNAUTHORIZED: u64 = 7;
    const EEXPIRED: u64 = 8;

    // Order types
    const ORDER_TYPE_BUY: u8 = 0;
    const ORDER_TYPE_SELL: u8 = 1;

    // Order status
    const STATUS_OPEN: u8 = 0;
    const STATUS_MATCHED: u8 = 1;
    const STATUS_COMPLETED: u8 = 2;
    const STATUS_CANCELLED: u8 = 3;
    const STATUS_DISPUTED: u8 = 4;

    // Constants
    const ORDER_EXPIRATION: u64 = 86400; // 24 hours in seconds
    const MIN_REPUTATION: u64 = 0;
    const MAX_REPUTATION: u64 = 100;

    // Core structs
    struct Market has key {
        id: UID,
        pairs: Table<String, TradingPair>,
        escrow_services: Table<address, EscrowService>,
        orders_count: u64,
        active_orders: vector<ID>,
    }

    struct TradingPair has store {
        base_asset: String,
        quote_asset: String,
        min_trade_amount: u64,
        max_trade_amount: u64,
        is_active: bool,
    }

    struct EscrowService has store {
        address: address,
        name: String,
        reputation: u64,
        total_trades: u64,
        successful_trades: u64,
        is_active: bool,
    }

    struct Order has key {
        id: UID,
        creator: address,
        order_type: u8,
        base_asset: String,
        quote_asset: String,
        amount: u64,
        price: u64,
        payment_methods: vector<String>,
        escrow_service: Option<address>,
        status: u8,
        matched_with: Option<ID>,
        created_at: u64,
        expires_at: u64,
    }

    struct Trade has key {
        id: UID,
        order_id: ID,
        maker: address,
        taker: address,
        amount: u64,
        price: u64,
        escrow_service: address,
        status: u8,
        created_at: u64,
        completed_at: Option<u64>,
    }

    // Events
    struct OrderCreated has copy, drop {
        order_id: ID,
        creator: address,
        order_type: u8,
        base_asset: String,
        quote_asset: String,
        amount: u64,
        price: u64,
        payment_methods: vector<String>,
    }

    struct OrderMatched has copy, drop {
        order_id: ID,
        matcher_id: ID,
        taker: address,
        escrow_service: address,
    }

    struct TradeCompleted has copy, drop {
        trade_id: ID,
        order_id: ID,
        maker: address,
        taker: address,
        amount: u64,
        price: u64,
    }

    struct TradingPairAdded has copy, drop {
        base_asset: String,
        quote_asset: String,
        min_trade_amount: u64,
        max_trade_amount: u64,
    }

    // Initialize market
    fun init(ctx: &mut TxContext) {
        let market = Market {
            id: object::new(ctx),
            pairs: table::new(ctx),
            escrow_services: table::new(ctx),
            orders_count: 0,
            active_orders: vector::empty(),
        };
        transfer::share_object(market);
    }

    // Trading pair management
    public fun add_trading_pair(
        market: &mut Market,
        base_asset: String,
        quote_asset: String,
        min_trade_amount: u64,
        max_trade_amount: u64,
        ctx: &mut TxContext
    ) {
        assert!(tx_context::sender(ctx) == @admin, EUNAUTHORIZED);

        let pair = TradingPair {
            base_asset: base_asset,
            quote_asset: quote_asset,
            min_trade_amount,
            max_trade_amount,
            is_active: true,
        };

        table::add(&mut market.pairs, get_pair_id(base_asset, quote_asset), pair);

        event::emit(TradingPairAdded {
            base_asset,
            quote_asset,
            min_trade_amount,
            max_trade_amount,
        });
    }

    // Escrow service management
    public fun register_escrow_service(
        market: &mut Market,
        name: String,
        service_address: address,
        ctx: &mut TxContext
    ) {
        assert!(tx_context::sender(ctx) == @admin, EUNAUTHORIZED);

        let service = EscrowService {
            address: service_address,
            name,
            reputation: MIN_REPUTATION,
            total_trades: 0,
            successful_trades: 0,
            is_active: true,
        };

        table::add(&mut market.escrow_services, service_address, service);
    }

    // Order creation and management
    public fun create_order<T>(
        market: &mut Market,
        coin: Coin<T>,
        order_type: u8,
        quote_asset: String,
        price: u64,
        payment_methods: vector<String>,
        clock: &Clock,
        ctx: &mut TxContext
    ) {
        let amount = coin::value(&coin);
        let base_asset = get_coin_type<T>();

        // Validate trading pair
        let pair_id = get_pair_id(base_asset, quote_asset);
        assert!(table::contains(&market.pairs, pair_id), EINVALID_PAIR);

        let pair = table::borrow(&market.pairs, pair_id);
        assert!(amount >= pair.min_trade_amount && amount <= pair.max_trade_amount, EINVALID_AMOUNT);
        assert!(price > 0, EINVALID_PRICE);

        let order = Order {
            id: object::new(ctx),
            creator: tx_context::sender(ctx),
            order_type,
            base_asset,
            quote_asset,
            amount,
            price,
            payment_methods,
            escrow_service: option::none(),
            status: STATUS_OPEN,
            matched_with: option::none(),
            created_at: clock::timestamp_ms(clock),
            expires_at: clock::timestamp_ms(clock) + ORDER_EXPIRATION,
        };

        vector::push_back(&mut market.active_orders, object::id(&order));
        market.orders_count = market.orders_count + 1;

        event::emit(OrderCreated {
            order_id: object::id(&order),
            creator: tx_context::sender(ctx),
            order_type,
            base_asset,
            quote_asset,
            amount,
            price,
            payment_methods,
        });

        transfer::share_object(order);
    }

    public fun match_order(
        market: &mut Market,
        order: &mut Order,
        escrow_service: address,
        clock: &Clock,
        ctx: &mut TxContext
    ) {
        // Validate order status and expiration
        assert!(order.status == STATUS_OPEN, EINVALID_ORDER_STATUS);
        assert!(clock::timestamp_ms(clock) < order.expires_at, EEXPIRED);

        // Validate escrow service
        assert!(table::contains(&market.escrow_services, escrow_service), EINVALID_ESCROW);
        let service = table::borrow_mut(&mut market.escrow_services, escrow_service);
        assert!(service.is_active, EINVALID_ESCROW);

        // Create trade
        let trade = Trade {
            id: object::new(ctx),
            order_id: object::id(order),
            maker: order.creator,
            taker: tx_context::sender(ctx),
            amount: order.amount,
            price: order.price,
            escrow_service,
            status: STATUS_MATCHED,
            created_at: clock::timestamp_ms(clock),
            completed_at: option::none(),
        };

        // Update order
        order.status = STATUS_MATCHED;
        order.escrow_service = option::some(escrow_service);
        order.matched_with = option::some(object::id(&trade));

        // Update escrow service stats
        service.total_trades = service.total_trades + 1;

        event::emit(OrderMatched {
            order_id: object::id(order),
            matcher_id: object::id(&trade),
            taker: tx_context::sender(ctx),
            escrow_service,
        });

        transfer::share_object(trade);
    }

    public fun complete_trade(
        market: &mut Market,
        trade: &mut Trade,
        order: &mut Order,
        clock: &Clock,
        ctx: &mut TxContext
    ) {
        assert!(trade.status == STATUS_MATCHED, EINVALID_ORDER_STATUS);
        assert!(tx_context::sender(ctx) == trade.maker || tx_context::sender(ctx) == trade.taker, EUNAUTHORIZED);

        // Update trade status
        trade.status = STATUS_COMPLETED;
        trade.completed_at = option::some(clock::timestamp_ms(clock));

        // Update order status
        order.status = STATUS_COMPLETED;

        // Update escrow service reputation
        let service = table::borrow_mut(&mut market.escrow_services, trade.escrow_service);
        service.successful_trades = service.successful_trades + 1;

        event::emit(TradeCompleted {
            trade_id: object::id(trade),
            order_id: trade.order_id,
            maker: trade.maker,
            taker: trade.taker,
            amount: trade.amount,
            price: trade.price,
        });
    }

    // Helper functions
    fun get_pair_id(base_asset: String, quote_asset: String): String {
        string::append(&mut base_asset, string::utf8(b"-"));
        string::append(&mut base_asset, quote_asset);
        base_asset
    }

    fun get_coin_type<T>(): String {
        // Implementation would vary based on how you want to handle type names
        string::utf8(b"SUI") // Placeholder
    }

    // Getters
    public fun get_order_status(order: &Order): u8 { order.status }
    public fun get_order_creator(order: &Order): address { order.creator }
    public fun get_order_type(order: &Order): u8 { order.order_type }
    public fun get_order_amount(order: &Order): u64 { order.amount }
    public fun get_order_price(order: &Order): u64 { order.price }
}
