def consolidate_cart(cart)
  new_cart = {}
  cart.each do |ingredient|
    if new_cart[ingredient.keys[0]]
      new_cart[ingredient.keys[0]][:count] += 1
    else
      new_cart[ingredient.keys[0]] = {
        count: 1,
        price: ingredient.values[0][:price],
        clearance: ingredient.values[0][:clearance]
      }
    end
  end
  new_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.keys.include? coupon[:ingredient]
      if cart[coupon[:ingredient]][:count] >= coupon[:num]
        new_name = "#{coupon[:ingredient]} W/COUPON"
        if cart[new_name]
          cart[new_name][:count] += coupon[:num]
        else
          cart[new_name] = {
            count: coupon[:num],
            price: coupon[:cost]/coupon[:num],
            clearance: cart[coupon[:ingredient]][:clearance]
          }
        end
        cart[coupon[:ingredient]][:count] -= coupon[:num]
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.keys.each do |ingredient|
    if cart[ingredient][:clearance]
      cart[ingredient][:price] = (cart[ingredient][:price]*0.80).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  consol_cart = consolidate_cart(cart)
  cart_with_coupons_applied = apply_coupons(consol_cart, coupons)
  cart_with_discounts_applied = apply_clearance(cart_with_coupons_applied)

  total = 0.0
  cart_with_discounts_applied.keys.each do |ingredient|
    total += cart_with_discounts_applied[ingredient][:price]*cart_with_discounts_applied[ingredient][:count]
  end
  total > 100.00 ? (total * 0.90).round : total
end