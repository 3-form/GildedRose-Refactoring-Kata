# frozen_string_literal: true

class GildedRose
  MIN_QUALITY = 0  # The quality of an item is never negative.
  MAX_QUALITY = 50 # The quality is never more than 50, except Sulfuras.

  AGED_NAME = 'Aged Brie'
  BACKSTAGE_NAME = 'Backstage passes to a TAFKAL80ETC concert'
  CONJURED_NAME = 'Conjured Mana Cake'
  SULFURAS_NAME = 'Sulfuras, Hand of Ragnaros'

  attr_accessor :items

  def initialize(items)
    @items = items
  end

  def update_quality
    items.each(&method(:update_item))
  end

  def update_item(item)
    # Sulfuras, being a legendary item, never has to be sold
    # or decreases in quality.
    return if item.name == SULFURAS_NAME

    update_item_quality(item)
    item.sell_in -= 1

    # Once the sell by date has passed, quality degrades twice as fast
    # so update quality again.
    update_item_quality(item) if item.sell_in.negative?
  end

  def update_item_quality(item)
    item.quality = (item.quality + quality_increment(item))
                   .clamp(MIN_QUALITY, MAX_QUALITY)
  end

  def quality_increment(item)
    case item.name
    when AGED_NAME
      1 # Aged Brie increases in quality the older it gets.
    when BACKSTAGE_NAME
      # "Backstage passes" ages like Brie, but in a more complicated way.
      backstage_quality_increment(item)
    when CONJURED_NAME
      -2 # Conjured items degrade in quality twice as fast as normal.
    else
      -1 # Normal items degrade by one.
    end
  end

  def backstage_quality_increment(item)
    if item.sell_in.negative?
      # Quality drops to zero after the concert.
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
