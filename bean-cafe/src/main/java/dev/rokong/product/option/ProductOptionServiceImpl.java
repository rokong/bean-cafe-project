package dev.rokong.product.option;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dev.rokong.dto.ProductOptionDTO;
import dev.rokong.exception.BusinessException;
import dev.rokong.product.main.ProductService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class ProductOptionServiceImpl implements ProductOptionService {
    
    @Autowired ProductOptionDAO pOptionDAO;

    @Autowired ProductService pService;

    public List<ProductOptionDTO> getPOptionList(ProductOptionDTO pOption){
        if(pOption.getProductId() == 0){
            log.debug("product option paramerter : "+pOption.toString());
            throw new BusinessException("product id must be declared");
        }else if(pOption.getOptionGroup() == null){
            if(pOption.getOptionId() != null && !"".equals(pOption.getOptionId())){
                log.debug("product option paramerter : "+pOption.toString());
                throw new BusinessException("option id should be empty until option group is not null");
            }
        }
        return pOptionDAO.selectProductOptionList(pOption);
    };

    public ProductOptionDTO getPOption(ProductOptionDTO pOption){
        this.verifyPrimaryKeysDefined(pOption);
        return pOptionDAO.selectProductOption(pOption);
    };

    public ProductOptionDTO getPOptionNotNull(ProductOptionDTO pOption){
        ProductOptionDTO getPOption = pOptionDAO.selectProductOption(pOption);
        if(getPOption == null){
            log.debug("product option paramerter : "+pOption.toString());
            throw new BusinessException("product option is not exists");
        }
        return getPOption;
    };

    public ProductOptionDTO createPOptionGroup(ProductOptionDTO pOption){
        //product id and name must be defined

        //option group will be created automatically

        //is product option name is defined
        if(pOption.getName() == null || "".equals(pOption.getName())){
            throw new BusinessException("option group's name is not defined");
        }

        //is product id exists
        pService.getProductNotNull(pOption.getProductId());

        //get list of option group
        ProductOptionDTO param = new ProductOptionDTO(pOption.getProductId());
        List<ProductOptionDTO> resultList = this.getPOptionList(param);
        
        //avoid duplicate product option group name
        for(ProductOptionDTO p : resultList){
            if("00".equals(p.getOptionId())
                    && p.getName().equals(pOption.getName())){
                log.debug("product option paramerter : "+pOption.toString());
                log.debug("duplicate product option : "+p.toString());
                throw new BusinessException("option group's name is duplicated");
            }
        }

        //calculate option group to be created
        int lastGroup = 0;
        if(resultList != null && resultList.size() != 0){
            lastGroup = resultList.get(resultList.size()-1).getOptionGroup();
        }

        if(lastGroup+1 > 10){
            throw new BusinessException("option group in each product can not exceed 10");
        }

        pOption.setOptionGroup(lastGroup+1);
        pOption.setOptionId("00");
        pOption.setOrd(0);

        pOptionDAO.insertProductOption(pOption);

        return this.getPOptionNotNull(pOption);
    }

    public ProductOptionDTO createPOption(ProductOptionDTO pOption){
        //product id, option group and name must be defined

        //pOption's option_id will be created automatically

        //is product option name is defined
        if(pOption.getName() == null || "".equals(pOption.getName())){
            throw new BusinessException("product option's name is not defined");
        }

        //is product id and option group exists
        ProductOptionDTO param = new ProductOptionDTO(
            pOption.getProductId(), pOption.getOptionGroup());
        List<ProductOptionDTO> optionList = this.getPOptionList(param);
        if(optionList == null || optionList.size() == 0){
            log.debug("product option paramerter : "+pOption.toString());
            throw new BusinessException("product & option group is not exists");
        }

        //is created option id exceed the limit in system
        String lastId = optionList.get(optionList.size()-1).getOptionId();
        String tobeId = ProductOptionDTO.nextId(lastId);

        if("00".equals(tobeId)){
            log.debug("product option paramerter : "+pOption.toString());
            throw new BusinessException("option Id exceed the limit");
        }
        
        pOption.setOptionId(tobeId);
        pOption.setOrd(optionList.size());

        //insert
        pOptionDAO.insertProductOption(pOption);

        return this.getPOptionNotNull(pOption);
    }

    public void deletePOption(ProductOptionDTO pOption){
        this.getPOptionNotNull(pOption);

        //if pOption is option group's title
        if("00".equals(pOption.getOptionId())){
            //get product option list in same group
            ProductOptionDTO param = new ProductOptionDTO(pOption.getProductId(), pOption.getOptionGroup());
            List<ProductOptionDTO> optionsInGrp = pOptionDAO.selectProductOptionList(param);

            if(optionsInGrp != null && optionsInGrp.size() > 1){
                //if there is the other option, throw exception
                log.debug("product option paramerter : "+pOption.toString());
                log.debug("the size of options in group : "+optionsInGrp.size()+" (this size should be 1)");
                throw new BusinessException("other option in same group exists");
            }

            //get product option list whose option group is pOption's option group +1
            param = new ProductOptionDTO(pOption.getProductId(), pOption.getOptionGroup()+1);
            List<ProductOptionDTO> lowerOptions = pOptionDAO.selectProductOptionList(param);
            
            if(lowerOptions != null && lowerOptions.size() > 0){
                //if lower group exists, throw exception
                log.debug("product option paramerter : "+pOption.toString());
                log.debug("lower option's option group : "+lowerOptions.get(0).getOptionGroup());
                throw new BusinessException("lower option group exist");
            }
        }

        /*
            2. change only option id
                product detail : if exists(asis ~ tobe), throw exception
                order product : set null option cd (asis ~ tobe)
                cart : cascade
        */

        log.debug("associated option cd in order product is set null");

        log.debug("associated product details are deleted");
        //TODO delete product detail associated with product option

        log.debug("associated option cd in cart is deleted");
        //TODO delete cart associated with product option

        pOptionDAO.deleteProductOption(pOption);
    }

    public ProductOptionDTO updatePOption(ProductOptionDTO asis, ProductOptionDTO tobePOption){
        //update name or ord
        ProductOptionDTO asisPOption = this.getPOptionNotNull(asis);

        if(tobePOption.getOrd() == null){
            throw new BusinessException("ord must be declared");
        }

        boolean isNameChange = !asisPOption.getName().equals(tobePOption.getName());
        boolean isOrdChange = asisPOption.getOrd() != tobePOption.getOrd();

        if(!isNameChange && !isOrdChange){
            //if nothing to be changed, return asis one
            return asisPOption;
        }

        //if option's name (except title) is going to be changed
        if(isNameChange && !"00".equals(asisPOption.getOptionId())){
            //get option list in same group
            ProductOptionDTO param = new ProductOptionDTO(
                asisPOption.getProductId(), asisPOption.getOptionGroup());
            List<ProductOptionDTO> optionsInGrp = this.getPOptionList(param);

            for(ProductOptionDTO o : optionsInGrp){
                if(!"00".equals(o.getOptionId())
                        && !asisPOption.getOptionId().equals(o.getOptionId())
                        && o.getName().equals(tobePOption.getName())){
                    //avoid duplicate option name (except option group's title and itself)
                    log.debug("asis product option paramerter : "+asis.toString());
                    log.debug("tobe product option paramerter : "+tobePOption.toString());
                    throw new BusinessException("duplicate name in same option group");
                }
            }
        }

        if(isNameChange){
            //TODO update product detail name
            pOptionDAO.updateProductOption(asisPOption, tobePOption.getName(), asisPOption.getOrd());
            asisPOption.setName(tobePOption.getName());
        }

        if(isOrdChange){
            this.rearrangeOptionOrder(asisPOption, tobePOption.getOrd());
        }
        
        return this.getPOptionNotNull(asisPOption);
    }

    public void deletePOptionGroup(ProductOptionDTO pOption){
        //check asis product option group exists
        ProductOptionDTO param = new ProductOptionDTO(pOption.getProductId());
        List<ProductOptionDTO> list = this.getPOptionList(param);
        if(list == null || list.size() == 0){
            //if nothing to delete, return void
            return;
        }

        //option group to be deleted
        int lastGroup = list.get(list.size()-1).getOptionGroup();
        pOption.setOptionGroup(lastGroup);

        //TODO delete associated product details

        pOptionDAO.deleteProductOption(pOption);
    }

    public ProductOptionDTO updatePOptionGroupOrder(ProductOptionDTO asisPOption, int tobeGroup){
        //check asis product option group exists
        ProductOptionDTO param = new ProductOptionDTO(asisPOption);
        param.setOptionId("00");    //find title
        this.getPOptionNotNull(param);

        //TODO select associated product details
        //if exists, throw exception

        //TODO set null option cd in order_product

        //TODO cart : cascade

        this.rearrangeOptionGroup(asisPOption, tobeGroup);

        param.setOptionGroup(tobeGroup);
        return this.getPOptionNotNull(param);
    }

    public void deletePOptionAll(int productId){
        //TODO delete associated product details

        pOptionDAO.deleteProductOption(new ProductOptionDTO(productId));
    }

    private void verifyPrimaryKeysDefined(ProductOptionDTO pOption){
        if(pOption.getProductId() == 0){
            log.debug("product option paramerter : "+pOption.toString());
            throw new BusinessException("product id must be declared");

        }else if(pOption.getOptionGroup() == null || pOption.getOptionGroup() == 0){
            log.debug("product option paramerter : "+pOption.toString());
            throw new BusinessException("option group must be declared");

        }else if(pOption.getOptionId() == null && "".equals(pOption.getOptionId())){
            log.debug("product option paramerter : "+pOption.toString());
            throw new BusinessException("option id must be declared");
        }
    }

    private void rearrangeOptionOrder(ProductOptionDTO asisPOption, int tobeOrder){
        if(tobeOrder == 0){
            throw new BusinessException("tobe order must be greater than 0");
        }else if(asisPOption.getOrd() == tobeOrder){
            return;
        }

        int asisOrder = asisPOption.getOrd();

        //to check tobeOrder beyonds max(order)
        int maxOrd = this.maxOrdInGroup(asisPOption);

        //prevent unique constraint (product_id, option_group, ord)
        pOptionDAO.updateProductOption(asisPOption, asisPOption.getName(), maxOrd+1);

        if(tobeOrder <= maxOrd){
            //if tobeOrder exists in max(order)

            if(tobeOrder < asisOrder){                      //move forward order
                //move backward between tobe and asis one
                pOptionDAO.backwardOptionOrder(asisPOption, tobeOrder, asisOrder);
            }else{                                          //move backward order
                //move forward between asis and tobe one
                pOptionDAO.forwardOptionOrder(asisPOption, asisOrder, tobeOrder);
            }

            //execute update only order
            pOptionDAO.updateProductOption(asisPOption, asisPOption.getName(), tobeOrder);
        }else{
            log.debug("tobe order exceed the max order. it will be appended last");
        }
    }

    private void rearrangeOptionGroup(ProductOptionDTO asisPOption, int tobeGroup){
        if(tobeGroup == 0){
            throw new BusinessException("tobe order must be greater than 0");
        }else if(asisPOption.getOptionGroup() == tobeGroup){
            return;
        }

        int asisGroup = asisPOption.getOptionGroup();

        //to check tobeGroup beyonds max(group)
        int maxGroup = this.maxGroupInProduct(asisPOption.getProductId());

        //prevent unique constraint (product_id, option_group, ord)
        pOptionDAO.updateOptionGroup(asisPOption, maxGroup+1);
        asisPOption.setOptionGroup(maxGroup+1);

        if(tobeGroup <= maxGroup){
            //if tobeOrder exists in max(order)

            if(tobeGroup < asisGroup){                      //move forward group
                //move backward between tobe and asis one
                pOptionDAO.backwardOptionGroup(asisPOption.getProductId(), tobeGroup, asisGroup);
            }else{                                          //move backward order
                //move forward between asis and tobe one
                pOptionDAO.forwardOptionGroup(asisPOption.getProductId(), asisGroup, tobeGroup);
            }

            //execute update only order
            pOptionDAO.updateOptionGroup(asisPOption, tobeGroup);
        }else{
            log.debug("tobe group exceed the max group. it will be appended last");
        }
    }

    private int maxGroupInProduct(int productId){
        List<ProductOptionDTO> list = this.getPOptionList(new ProductOptionDTO(productId));

        int maxGroup = 1;
        if(list != null && list.size() != 0){
            maxGroup = list.get(list.size()-1).getOptionGroup();
        }

        return maxGroup;
    }

    private Integer maxOrdInGroup(ProductOptionDTO pOption){
        ProductOptionDTO param = new ProductOptionDTO(pOption);
        param.setOptionId(null);
        List<ProductOptionDTO> list = this.getPOptionList(param);
        
        Integer maxOrd = null;
        if(list != null && list.size() != 0){
            maxOrd = list.get(list.size()-1).getOrd();
        }

        return maxOrd;
    }
}