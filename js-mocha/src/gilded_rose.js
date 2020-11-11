class Item {
  constructor(name, sellIn, quality) {
    this._quality = null;
    this.name = name;
    this.sellIn = sellIn;
    this.quality = quality;
  }

  get isAgedBrie() {
    return this.name === "Aged Brie";
  }

  get isBackstagePass() {
    return this.name === "Backstage passes to a TAFKAL80ETC concert";
  }

  get isSulfuras() {
    return this.name === "Sulfuras, Hand of Ragnaros";
  }

  get isConjured() {
    return this.name === "Conjured Mana Cake";
  }

  set quality(value) {
    if (this.isSulfuras) {
      this._quality = 80;
      return;
    }

    this._quality = Math.min(Math.max(0, value), 50);
  }

  get quality() {
    return this._quality;
  }

  get expired() {
    return this.sellIn < 0;
  }

  updateSellIn() {
    if (this.isSulfuras) {
      return;
    }

    this.sellIn -= 1;
  }

  qualityIncrement() {
    if (this.isBackstagePass) {
      if (this.expired) {
        return -this.quality;
      }

      return this.sellIn < 5 ? 3 : this.sellIn < 10 ? 2 : 1;
    }

    if (this.isAgedBrie) {
      return this.expired ? 2 : 1;
    }

    return (this.expired ? -2 : -1) * (this.isConjured ? 2 : 1);
  }

  update() {
    const updatedItem = new Item(this.name, this.sellIn, this.quality);
    updatedItem.updateSellIn();
    updatedItem.quality += updatedItem.qualityIncrement();

    return updatedItem;
  }
}

class Shop {
  constructor(items = []) {
    this.items = items;
  }
  updateQuality() {
    this.items = this.items.map((item) => item.update());

    return this.items;
  }
}
module.exports = {
  Item,
  Shop,
};
