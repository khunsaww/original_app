import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["newQuantity", "usedQuantity", "unitPrice", "total"]
  static values = {
    originalNewQuantity: Number,
    originalUsedQuantity: Number,
    persisted: Boolean
  }

  connect() {
    this.updateTotal()
  }

  parsed(target) {
    const value = parseInt(target.value || "0", 10)
    return Number.isFinite(value) ? value : 0
  }

  updateTotal() {
    const quantity = this.parsed(this.newQuantityTarget) + this.parsed(this.usedQuantityTarget)
    const unitPrice = this.parsed(this.unitPriceTarget)
    this.totalTarget.textContent = (quantity * unitPrice).toLocaleString("ja-JP")
  }

  confirmQuantity(event) {
    if (!this.persistedValue) return

    const nextNew = this.newQuantityTarget.value
    const nextUsed = this.usedQuantityTarget.value
    const prevNew = String(this.originalNewQuantityValue)
    const prevUsed = String(this.originalUsedQuantityValue)
    if (nextNew === prevNew && nextUsed === prevUsed) return

    const ok = window.confirm(
      `数量を 新品 ${prevNew} / 使用済み ${prevUsed} から 新品 ${nextNew} / 使用済み ${nextUsed} に変更します。よろしいですか？`
    )
    if (!ok) event.preventDefault()
  }
}
