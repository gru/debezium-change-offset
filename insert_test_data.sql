-- Вставка тестовых данных в таблицу outbox
INSERT INTO public.outbox (id, aggregatetype, aggregateid, type, payload)
VALUES 
    (gen_random_uuid(), 'Order', '12345', 'OrderCreated', '{"orderId": "12345", "customerId": "C001", "totalAmount": 100.50}'::jsonb),
    (gen_random_uuid(), 'Customer', 'C001', 'CustomerUpdated', '{"customerId": "C001", "name": "Иван Иванов", "email": "ivan@example.com"}'::jsonb),
    (gen_random_uuid(), 'Product', 'P789', 'ProductAdded', '{"productId": "P789", "name": "Новый продукт", "price": 29.99}'::jsonb),
    (gen_random_uuid(), 'Order', '67890', 'OrderCancelled', '{"orderId": "67890", "reason": "Отменено клиентом"}'::jsonb),
    (gen_random_uuid(), 'Inventory', 'SKU123', 'StockUpdated', '{"sku": "SKU123", "quantity": 50, "warehouseId": "W001"}'::jsonb);
