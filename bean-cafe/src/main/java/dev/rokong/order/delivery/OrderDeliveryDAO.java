package dev.rokong.order.delivery;

import java.util.List;

import dev.rokong.dto.OrderDeliveryDTO;

public interface OrderDeliveryDAO {
    public OrderDeliveryDTO select(OrderDeliveryDTO oDelivery);
    public int count(OrderDeliveryDTO oDelivery);
    public void insert(OrderDeliveryDTO oDelivery);
    public void delete(OrderDeliveryDTO oDelivery);

    /**
     * update price, statusCd, shipCd which are defined
     *
     * @param oDelivery
     */
    public void update(OrderDeliveryDTO oDelivery);
    public List<OrderDeliveryDTO> selectByOrder(int orderId);
}