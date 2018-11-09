require "pry"
def consolidate_cart(cart)
  # code here
  consolidate = Hash.new 
  cart.each do |object_data|
   object_data.each do |name, data| 
    if consolidate[name] == nil 
      consolidate[name] = data.merge({:count => 1})
    else 
      consolidate[name][:count] += 1
    end 
   end 
  end 
  consolidate
end

def apply_coupons(cart, coupons)
  # code here
  new_cart = cart
  coupons.each do|coupon_hash| 
    item = coupon_hash[:item]
    
    if !new_cart[item].nil? && new_cart[item][:count] >= coupon_hash[:num]
      
      clearance = {"#{item} W/COUPON" => {
          :price => coupon_hash[:cost],
          :clearance => new_cart[item][:clearance],
          :count => 1
          }
        }
      
      if new_cart["#{item} W/COUPON"].nil? 
        new_cart.merge!(clearance)
      else 
        new_cart["#{item} W/COUPON"][:count] += 1 
      end 
      
      new_cart[item][:count] -= coupon_hash[:num]
    end 
  end
  new_cart
end

def apply_clearance(cart)
  # code here
  cart.each do |item, data| 
    if data[:clearance] == true
      data[:price] = (data[:price]* 0.8).round(2)
    end 
  end 
  cart
end

def checkout(cart, coupons)
  # code here
  cart = consolidate_cart(cart)
  new_cart = apply_coupons(cart, coupons)
  p update = apply_clearance(new_cart)
  
  cart_total = 0 
  
  update.each do |item, data| 
    cart_total += data[:price] * data[:count]
  end 
  
  cart_total > 100 ? cart_total * 0.9 : cart_total
end
