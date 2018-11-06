def consolidate_cart(cart)
  # code here
  # .each_with_object iterates the given block for each element with an
  # arbitrary object given, and returns the initially given object.
  cart.each_with_object({}) do |item, hash|
    # over each element/object pair, iterate over the food type/attribute pair
    item.each do |type, attributes|
      # if type already exists
      if hash[type]
        # increment count by 1
        attributes[:count] += 1
      else
        # because type doesn't already exist, create a count attribute equal to 1 item
        attributes[:count] = 1
        # and update attributes
        hash[type] = attributes
      end
    end
  end
end

def apply_coupons(cart, coupons)
  # code here
  # iterate over each coupon
  coupons.each do |coupon|
    # set the coupon's :item attribute equal to "item" and :num to num
    item = coupon[:item]
    num = coupon[:num]
    # if the cart has an item in w/ a coupon and the required num
    # for coupon is great than or equal to count in cart,
    if cart[item] && cart[item][:count] >= num
      # if there is already a coupon applied
      if cart["#{item} W/COUPON"]
        # increment the coupon count
        cart["#{item} W/COUPON"][:count] += 1
      # if there is no coupon applied
      else
        # add the first coupon by count = 1 and
        # set price to new coupon price
        cart["#{item} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        # remembers the item was on clearance
        cart["#{item} W/COUPON"][:clearance] = cart[item][:clearance]
      end
      # reduce the number of items in the cart by
      # the number of items needed for each coupon
      cart[item][:count] -= num
    end
  end
  #return the cart
  cart
end

def apply_clearance(cart)
  # code here
  # iterate over each item/attribute pair in the cart
  cart.each do |item, attributes|
    # if there clearance element in attributes is true
    if attributes[:clearance]
      # set clearance_price equal to the old price w/ a 20% discount
      clearance_price = attributes[:price] * 0.8
      # set the price attribute equal to the new price rounded to 2 decimal places
      attributes[:price] = clearance_price.round(2)
    end
  end
  # return cart
  cart
end

def checkout(cart, coupons)
  # code here
  # calls on consolidate_cart
  updated_cart = consolidate_cart(cart)
  # applies coupons to updated cart
  cart_with_coupons = apply_coupons(updated_cart, coupons)
  # applies clearance to the cart w/ coupons applied
  cart_total = apply_clearance(cart_with_coupons)
  # initialize total and set equal to zero
  total = 0
  # for each item/attribute pair in the cart
  cart_total.each do |item, attributes|
    # add the price x count to the total
    total += attributes[:price] * attributes[:count]
  end
  # applies a 10% discount if the cart is over $100
  if total > 100
    total = total * 0.9
  end
  # return total
  total
end
