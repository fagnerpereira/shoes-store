import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="charts"
export default class extends Controller {
  static targets = [
    'sales', 'salesByProducts', 'salesByStores',
    'filterDays', 'filterInterval', 'total'
  ]

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

  // i had to make a fetch not using charkick api, since the api has not event or doesnt return a promise after fetch endpoint
  async renderSalesChart() {
    const response = await fetch(`/sales_by_stores?${this.filterQuery()}`);
    const data = await response.json();
    const values = Object.values(data);

    if (values.length === 0) return;

    let total = Object.values(data).reduce( (acc, curr) => acc + curr );

    this.totalTarget.textContent = total.toLocaleString(
      'en-US',
      { style: 'currency', currency: 'USD' }
    );
    new Chartkick.LineChart(
      this.salesTarget,
      data
    );
  }

  renderSalesByStoresChart() {
    new Chartkick['BarChart'](
      this.salesByStoresTarget,
      `/top_sales_by_stores?${this.filterQuery()}`,
      { colors: ['#8258D9'] }
    )
  }

  renderSalesByProductsChart() {
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
