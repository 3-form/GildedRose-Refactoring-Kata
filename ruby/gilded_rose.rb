# frozen_string_literal: true

class GildedRose
  MIN_QUALITY = 0
  MAX_QUALITY = 50

  AGED_NAME = 'Aged Brie'
  BACKSTAGE_NAME = 'Backstage passes to a TAFKAL80ETC concert'
  CONJURED_NAME = 'Conjured Mana Cake'
  SULFURAS_NAME = 'Sulfuras, Hand of Ragnaros'

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each(&method(:update_item))
  end

  def update_item(item)
    return if item.name == SULFURAS_NAME

    update_item_quality(item)
    item.sell_in -= 1
    update_item_quality(item) if item.sell_in.negative?
  end

  def update_item_quality(item)
    item.quality = (item.quality + quality_increment(item))
                   .clamp(MIN_QUALITY, MAX_QUALITY)
  end

  def quality_increment(item)
    case item.name
    when AGED_NAME
      1
    when BACKSTAGE_NAME
      backstage_quality_increment(item)
    when CONJURED_NAME
      -2
    else
      -1
    end
  end

  def backstage_quality_increment(item)
    if item.sell_in.negative?
      -item.quality
    elsif item.sell_in <= 5
      3
    elsif item.sell_in <= 10
      2
    else
      1
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name:, sell_in:, quality:)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
