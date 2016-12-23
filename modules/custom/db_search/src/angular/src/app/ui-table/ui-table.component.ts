import {
  AfterViewInit,
  Component,
  ElementRef,
  EventEmitter,
  Input,
  OnInit,
  OnChanges,
  Output,
  Renderer,
  SimpleChanges,
  ViewChild,
  ViewEncapsulation
} from '@angular/core';

import { Column } from './column';

@Component({
  selector: 'ui-table',
  templateUrl: './ui-table.component.html',
  styleUrls: ['./ui-table.component.css'],
  encapsulation: ViewEncapsulation.None
})
export class UiTableComponent implements OnChanges {

  @Input() data: Column[];
  @Input() columns;

  @Input() loading: boolean;
  @Input() numResults: number;
  @Input() pageSizes: number[];

  @Output() sort: EventEmitter<{ "column": string, "type": "asc" | "desc" }>;
  @Output() paginate: EventEmitter<{ "size":number, "offset":number }>;

  @ViewChild('thead') thead: ElementRef;
  @ViewChild('tbody') tbody: ElementRef;

  pagingModel: number;
  pageOffset: number;
  pageSize: number;

  mCol: Column[];
  mData: any[];

  constructor(private renderer: Renderer) {
    this.columns = [];
    this.data = [];
    
    this.loading = true;
    this.pageOffset = 0;

    this.sort = new EventEmitter<{ "column": string, "type": "asc" | "desc" }>();
    this.paginate = new EventEmitter<{ "size":number, "offset":number }>();
  }

  ngAfterViewInit() {
//    this.drawTable(this.mCol, this.mData);
  }

  pageChanged(event: any) {
    this.pageOffset = event.page;
    this.updatePagination();
  }

  updatePageSize(event) {
    this.pageSize = +event;
    this.pagingModel = 1;
    this.updatePagination()
  }

  updatePagination() {
    let offset = this.pageOffset || 1;
    let size = this.pageSize;

    this.paginate.emit({
      size: size,
      offset: (offset - 1) * size
    })
  }

  drawTableHeader(columns: Column[]){
    
    let thead = this.thead.nativeElement;
    this.clearChildren(thead);

    let headerRow = this.renderer.createElement(
      thead,
      'tr'
    )

    for (let column of columns) {
      let headerCell: HTMLTableHeaderCellElement = this.renderer.createElement(
        headerRow,
        'th'
      )

      this.renderer.listen(
        headerCell,
        'click',
        (event) => {
          column.sort = (column.sort === 'asc') ? 'desc' : 'asc';
          this.drawTableHeader(columns);
          this.sort.emit({
            column: column.value,
            type: column.sort
          })
        }
      )

      this.renderer.createText(
        headerCell,
        column.label
      )

      let headerSortDiv: HTMLDivElement = this.renderer.createElement(
        headerCell,
        'span'
      )

      this.renderer.createText(
        headerSortDiv,
        column.sort === 'asc' ? '▲' : '▼'
      )

      this.renderer.setElementClass(
        headerSortDiv,
        'cell-background',
        true
      )
    }
  }

  drawTableBody(columns: Column[], data: any[]) {
    let tbody = this.tbody.nativeElement;
    this.clearChildren(tbody);

    for (let row of data) {

      let tableRow = this.renderer.createElement(
        tbody,
        'tr'
      )

      for (let column of columns) {

        let tableCell: HTMLTableCellElement = this.renderer.createElement(
          tableRow,
          'td'
        )

        if (!column.link) {
          let label: HTMLSpanElement = this.renderer.createElement(
            tableCell,
            'span'
          )

          this.renderer.createText(
            label,
            row[column.value]
          )
        }
        
        else {

          let link: HTMLElement = this.renderer.createElement(
            tableCell,
            'a'
          )

          this.renderer.createText(
            link,
            row[column.value]
          )

          this.renderer.setElementAttribute(
            link,
            'href',
            row[column.link]
          )

          this.renderer.setElementAttribute(
            link,
            'target',
            '_blank'
          )
        }
      }
    }
  }

  drawTable(columns: Column[], data: any[]) {
    this.drawTableHeader(columns);
    this.drawTableBody(columns, data);
  }

  ngOnChanges(changes: SimpleChanges) {

    console.log('CHANGES', changes);
    console.log('col ', this.columns)
    console.log('data ', this.data)
    
    this.pageSize = this.pageSizes[0];

    this.drawTable(this.columns, this.data);
    
    if (changes['columns'])
      this.initSort(this.columns)
  }

  clearChildren(el: HTMLElement) {
    while (el.firstChild) {
      this.renderer.invokeElementMethod(
        el,
        'removeChild',
        [el.firstChild]
      )
    }
  }


  initSort(columns: Column[]) {
    columns.forEach(column => column.sort = 'asc');
  }
    

  initMockData() {

    this.mCol = [
      {
        value: 'title',
        label: 'Project Title',
        link: 'url'
      },
      {
        value: 'institution',
        label: 'Institution'
      },
      {
        value: 'lastName',
        label: 'Name'
      },
      {
        value: 'city',
        label: 'City'
      },
      {
        value: 'state',
        label: 'State'
      },
      {
        value: 'country',
        label: 'Country'
      },
      {
        value: 'fundingOrg',
        label: 'Funding Organization'
      },
    ]

    this.mData = [
      {
        "projectID": 55109,
        "title": "\"\"BCR/ABL-PI-3k-ROS pathway induce genomic instability ....\"\"",
        "lastName": "Skorski",
        "firstName": "Tomasz",
        "institution": "Temple University",
        "city": "Philadelphia",
        "state": "PA",
        "country": "US",
        "fundingOrg": "National Cancer Institute",
        "url": "http://localhost/drupal/ViewProject/55109",
      },
      {
        "projectID": 56428,
        "title": "\"\"Cancer Immunotherapy by Targeting A2 Adenosine Receptor\"\"",
        "lastName": "Sitkovsky",
        "firstName": "Michail",
        "institution": "Northeastern University",
        "city": "Boston",
        "state": "MA",
        "country": "US",
        "fundingOrg": "National Cancer Institute",
        "url": "http://localhost/drupal/ViewProject/56428",
      },
      {
        "projectID": 49892,
        "title": "\"\"Cluster Bombing\"\" of Neighbor Antioxidant & Breast Tumor Suppressor Loci",
        "lastName": "Burton",
        "firstName": "Frank",
        "institution": "Minnesota, University of, Twin Cities",
        "city": "Minneapolis",
        "state": "MN",
        "country": "US",
        "fundingOrg": "U. S. Department of Defense, CDMRP",
        "url": "http://localhost/drupal/ViewProject/49892",
      }
    ]    
  }
}