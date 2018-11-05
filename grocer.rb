cart=[
  {"AVOCADO" => {:price => 3.0, :clearance => true }},
  {"AVOCADO" => {:price => 3.0, :clearance => true }},
  {"KALE"    => {:price => 3.0, :clearance => false}}
]

def consolidate_cart(cart)
  consolidatedcart={}
  cart.each do |item|
    name=item.keys[0]
    price=item.values[0][:price]
    clearance=item.values[0][:clearance]
    if consolidatedcart.keys.include?(name)
      consolidatedcart[name][:count]=consolidatedcart[name][:count]+1
    else
      consolidatedcart[name]={}
      consolidatedcart[name][:price]=price
      consolidatedcart[name][:clearance]=clearance
      consolidatedcart[name][:count]=1
    end
  end
  return consolidatedcart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.keys.include?(coupon[:item])
      item=coupon[:item]
      number=cart[item][:count]
      bundlesize=coupon[:num]
      bundlecost=coupon[:cost]
      if cart.keys.include?("#{coupon[:item]} W/COUPON")
        if cart[item][:count]>=bundlesize
          item=coupon[:item]
          couponstring=item+" W/COUPON"
          cart[item][:count]=cart[item][:count]-bundlesize
          cart[couponstring][:count]+=1
        end
      else
        if cart[item][:count]>=bundlesize
          cart[item][:count]=cart[item][:count]-bundlesize
        end
        couponstring=item+" W/COUPON"
        cart[couponstring]={price: bundlecost, clearance: cart[item][:clearance], count:1}
      end
    end
  end
  return cart
end

def apply_clearance(cart)
  cart.each do |itemname, itemdata|
    if itemdata[:clearance]==true
      itemdata[:price]=itemdata[:price]-itemdata[:price]*0.2
    end
  end
  return cart
end

def checkout(cart, coupons)
  total=0
  cart=consolidate_cart(cart)
  cart=apply_coupons(cart, coupons)
  cart=apply_clearance(cart)
  cart.each do |item, data|
    total=total+data[:price]*data[:count]
  end
  if total>100
    total=total-total*0.1
  end
  return total
end
