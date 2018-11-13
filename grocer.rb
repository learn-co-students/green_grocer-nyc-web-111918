require 'pry'
def consolidate_cart(cart)
    cart.each_with_object({}) do |items, hash|
    items.each do |food, data|
      if hash.has_key?(food)
        data[:count] += 1
      else
        data[:count] = 1
        hash[food] = data
      end
    end
  end
end

def apply_coupons(cart, coupons)
    coupons.each do |coupon|
      if cart.has_key?(coupon[:item]) && cart[coupon[:item]][:count] >= coupon[:num]
        hash = {"#{coupon[:item]} W/COUPON" => {
          count: 1,
          clearance: cart[coupon[:item]][:clearance],
          price: coupon[:cost]
        }}
      if  cart["#{coupon[:item]} W/COUPON"].nil?
          cart.merge!(hash)
      else
          cart["#{coupon[:item]} W/COUPON"][:count] += 1
      end
        cart["#{coupon[:item]}"][:count] -= coupon[:num]
      end
    end
  cart
end

def apply_clearance(cart)
  cart.map do |item, data|
    if data[:clearance] == true
      data[:price] = (data[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  total = 0
  consolidated_cart = consolidate_cart(cart)
  applied_coupons = apply_coupons(consolidated_cart, coupons)
  clearance = apply_clearance(applied_coupons)
  clearance.each do |item, data|
    total += data[:price] * data[:count]
  end
  if total > 100
    total *= 0.9
  end
  total
end
