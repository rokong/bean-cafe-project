package dev.rokong.pay.api;

import dev.rokong.dto.OrderDTO;
import dev.rokong.dto.PayStatusDTO;
import dev.rokong.exception.BusinessException;
import dev.rokong.order.main.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/pay/api")
public class PayApiController {

    @Autowired
    OrderService orderService;

    @Autowired @Qualifier("tossService")
    PayApiService tossService;

    @RequestMapping(value="/{orderId}", method= RequestMethod.POST)
    public String requestPayment(@PathVariable int orderId){
        return this.makeRequest(orderId);
    }

    @RequestMapping("/{orderId}/status")
    public PayStatusDTO paymentStatus(@PathVariable int orderId){
        return this.getPayStatus(orderId);
    }

    private String makeRequest(int orderId){
        OrderDTO order = orderService.getOrderNotNull(orderId);

        if(tossService.getPayTypeId() == order.getPayId()){
            return tossService.makeRequest(orderId);
            //TODO add another API service
        }else{
            throw new BusinessException("no API service available");
        }
    }

    private PayStatusDTO getPayStatus(int orderId){
        OrderDTO order = orderService.getOrderNotNull(orderId);

        if(tossService.getPayTypeId() == order.getPayId()){
            return tossService.getPayStatus(orderId);
            //TODO add another API service
        }else{
            throw new BusinessException("no API service available");
        }
    }
}