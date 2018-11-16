require "pry"
def consolidate_cart(cart)
  new_cart = {}
  cart.each do |item|
    item.each do |item_name, item_data|
      if new_cart[item_name].nil?
        new_cart[item_name] = item_data
        new_cart[item_name][:count] = 1
      else 
        new_cart[item_name][:count] += 1
      end
    end
  end
  new_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon_hash|
    item = coupon_hash[:item]
    if cart.keys.include?(item) && cart[item][:count] >= coupon_hash[:num]
      cart[item][:count] -= coupon_hash[:num]
      discounted_item = "#{coupon_hash[:item]} W/COUPON"
      if cart[discounted_item].nil?
        cart[discounted_item] = {}
        cart[discounted_item][:price] = coupon_hash[:cost]
        cart[discounted_item][:clearance] = cart[item][:clearance] 
        cart[discounted_item][:count] = 1
       else
         cart[discounted_item][:count] += 1
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.map do |item, data|
    if data[:clearance] == true 
      cart[item][:price] *= 0.8
    end
    cart[item][:price] = cart[item][:price].round(1)
  end
  cart
end

def checkout(cart, coupons)
  total = 0
  cart = consolidate_cart(cart)
  
  if cart.length == 1
    cart = apply_coupons(cart, coupons)
    cart_clearance = apply_clearance(cart)
    if cart_clearance.length > 1
      cart_clearance.each do |item, details|
        if details[:count] >=1
          total += (details[:price]*details[:count])
        end
      end
    else
      cart_clearance.each do |item, details|
        total += (details[:price]*details[:count])
      end
    end
  else
    cart = apply_coupons(cart, coupons)
    cart_clearance = apply_clearance(cart)
    cart_clearance.each do |item, details|
      total += (details[:price]*details[:count])
    end
  end
  

  if total > 100
    total = total*(0.90)
  end
  total

end
