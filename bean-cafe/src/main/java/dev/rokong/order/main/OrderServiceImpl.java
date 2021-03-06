package dev.rokong.order.main;

import dev.rokong.annotation.OrderStatus;
import dev.rokong.dto.OrderDTO;
import dev.rokong.dto.OrderProductDTO;
import dev.rokong.exception.BusinessException;
import dev.rokong.order.delivery.OrderDeliveryService;
import dev.rokong.order.product.OrderProductService;
import dev.rokong.pay.type.PayTypeService;
import dev.rokong.user.UserService;
import dev.rokong.util.ObjUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.lang.reflect.Method;
import java.util.List;

@Slf4j
@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    OrderDAO orderDAO;

    @Autowired
    OrderProductService oProductService;

    @Autowired
    OrderDeliveryService oDeliverySerivce;

    @Autowired
    UserService userService;

    @Autowired
    PayTypeService pTypeService;

    public OrderDTO getOrder(int id){
        return orderDAO.select(id);
    }

    public OrderDTO getOrderNotNull(int id){
        OrderDTO order = this.getOrder(id);
        if(order == null){
            log.debug("order id : "+id);
            throw new BusinessException("order is not exists");
        }
        return order;
    }

    public void checkOrderExist(int id){
        if(id == 0){
            throw new IllegalArgumentException("order id is not defined");
        }

        if (orderDAO.count(id) == 0) {
            throw new BusinessException(id+" order is not exists");
        }
    }

    public OrderDTO getOrderNotNull(OrderDTO order){
        return this.getOrderNotNull(order.getId());
    }

    public OrderDTO createOrder(OrderDTO order) {
        //initialize order

        /*
        order process
        1. init order : create primary key
        2. add products
        3. add others info in order
        4. add delivery
        5. order complete
        */

        //userNm is required
        userService.checkUserExist(order.getUserNm());

        //set status
        order.setOrderStatus(OrderStatus.WRITING);

        //insert
        int id = orderDAO.insert(order);

        //if payId exists, update it
        if (order.getPayId() != null) {
            order.setId(id);
            this.updateOrderPay(order);
        }

        return this.getOrderNotNull(id);
    }

    public void updateOrderPrice(int id){
        //used by order.product
        this.checkOrderExist(id);

        OrderDTO order = new OrderDTO(id);
        int price = oDeliverySerivce.totalPrice(id);
        order.setPrice(price);

        orderDAO.updatePrice(order);
    }

    public void updateOrderDeliveryPrice(int id){
        //used by order.product
        this.checkOrderExist(id);

        OrderDTO order = new OrderDTO(id);
        int deliveryPrice = oDeliverySerivce.totalDeliveryPrice(id);
        order.setDeliveryPrice(deliveryPrice);

        orderDAO.updateDeliveryPrice(order);
    }

    public void updateOrderPay(OrderDTO order){
        //order id and pay id required
        this.getOrderNotNull(order);

        //get pay name
        String payNm = pTypeService.getPayTypeFullNm(order.getPayId());
        order.setPayNm(payNm);

        orderDAO.updatePay(order);
    }

    public OrderDTO updateOrderStatus(OrderDTO order){
        //update order status through main order
        OrderStatus tobeStatus = order.getOrderStatus();

        //verify tobe order status
        if (tobeStatus.isProcess()) {
            //if tobe status is normal process
            OrderStatus mainStatus = tobeStatus.getMainProcess();
            if (mainStatus != OrderStatus.WRITING
                    && mainStatus != OrderStatus.PAYMENT
                    && mainStatus != OrderStatus.CHECKING) {
                log.debug("tobe order status : {}", tobeStatus.name());
                throw new BusinessException("order status is not allowed in main order");
            }
        } else {
            //if tobe status is cancel
            if(tobeStatus != OrderStatus.CANCELED_WRITE
                    && tobeStatus != OrderStatus.CANCELED_PAYMENT){
                log.debug("tobe order status : {}", tobeStatus.name());
                throw new BusinessException("order status is not allowed in main order");
            }
        }

        //check order exists
        this.getOrderNotNull(order);

        //set editor name as customer and update
        orderDAO.updateOrderStatus(order);

        //update order product in specific status
        if(tobeStatus == OrderStatus.CHECKING || tobeStatus.isCanceled()){
            oDeliverySerivce.updateStatusByOrder(order.getId(), tobeStatus);
        }

        return this.getOrderNotNull(order);
    }

    public void updateOrderStatus(int id){
        //referred by order product

        //verify parameter
        if (id == 0) {
            throw new BusinessException("order id is not defined");
        }

        //get existing order
        OrderDTO order = this.getOrderNotNull(id);

        //get tobe order status
        OrderStatus tobeStatus = oDeliverySerivce.getProperOrderStatus(id);

        if(order.getOrderStatus() != tobeStatus){
            //update only status is changed
            order.setOrderStatus(tobeStatus);
            orderDAO.updateOrderStatus(order);
        }
    }

    public String getOrderDesc(int id){
        this.checkOrderExist(id);

        List<OrderProductDTO> list
                = oProductService.getOProducts(new OrderProductDTO(id));

        StringBuffer sbuf = new StringBuffer();

        //order product is not exists
        if(ObjUtil.isEmpty(list)){
            return "";
        }

        sbuf.append(list.get(0).getProductNm());
        if(list.size() > 1){
            sbuf.append(" 외 ")
                    .append(list.size()-1)
                    .append("건");
        }

        return sbuf.toString();
    }

    public OrderStatus getProperOrderStatus(List<?> list){
        //if list is empty, return WRITING
        if(ObjUtil.isEmpty(list)){
            return OrderStatus.WRITING;
        }

        //verify list object's class
        Class<?> clazz = list.get(0).getClass();
        Method m = null;
        try {
            m = clazz.getMethod("getOrderStatus");
        } catch (NoSuchMethodException e) {
            log.debug("class : {}, method name : {}", clazz.toString(), "getOrderStatus");
            throw new RuntimeException("class does not have method");
        }

        //the result of method
        OrderStatus lastProcess = null;

        OrderStatus status = null;
        for(Object o : list){
            try {
                status = (OrderStatus) m.invoke(o);
            } catch (ReflectiveOperationException e) {
                log.debug("method name : {}, object : {}", m.toString(), o.toString());
                throw new RuntimeException("can not invoke method");
            }

            if(status != null && status.isProcess()){
                //set last process when first or get former one
                if (lastProcess == null || status.isFormerThan(lastProcess)) {
                    log.debug("status : {}", status.name());
                    lastProcess = status;
                }
            }
        }

        //if last process is null, all products are canceled
        return (lastProcess != null) ? lastProcess : OrderStatus.CANCEL;
    }
}