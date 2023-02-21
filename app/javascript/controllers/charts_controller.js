import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="charts"
export default class extends Controller {
  static targets = ['sales', 'salesByProducts', 'salesByStores', 'filterDays', 'filterInterval']

  connect() {
    this.disabledFilterIntervalOption();
  }

  salesTargetConnected() {
    this.renderSalesChart();
  }

  salesByStoresTargetConnected() {
    this.renderSalesByStoresChart();
  }

  salesByProductsTargetConnected() {
    this.renderSalesByProductsChart();
  }

  fetchData() {
    this.disabledFilterIntervalOption();
    this.renderSalesChart();
    this.renderSalesByStoresChart();
    this.renderSalesByProductsChart();
  }

  renderSalesChart() {
    console.log('sales')
    new Chartkick['LineChart'](
      this.salesTarget,
      `/sales_by_stores?${this.filterQuery()}`
    )
  }

  renderSalesByStoresChart() {
    console.log('sales by stores')
    new Chartkick['BarChart'](
      this.salesByStoresTarget,
      `/top_sales_by_stores?${this.filterQuery()}`,
      { colors: ['#8258D9'] }
    )
  }

  renderSalesByProductsChart() {
    console.log('sales by products')
    new Chartkick['BarChart'](
      this.salesByProductsTarget,
      `/top_sales_by_products?${this.filterQuery()}`,
      { colors: ['#E81370'] }
    )
  }

  disabledFilterIntervalOption() {
    const monthlyOption = this.filterIntervalTarget.options[this.filterIntervalTarget.length - 1];

    if (this.filterDaysTarget.value === '7') {
      monthlyOption.disabled = true;
    } else {
      monthlyOption.disabled = false;
    }
  }

  filterQuery() {
    let days = this.filterDaysTarget.value;
    let interval = this.filterIntervalTarget.value;

    return `filter_days=${days}&filter_interval=${interval}`;
  }
}
