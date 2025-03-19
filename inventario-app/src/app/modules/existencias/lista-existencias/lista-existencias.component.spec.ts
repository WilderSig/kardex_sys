import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ListaExistenciasComponent } from './lista-existencias.component';

describe('ListaExistenciasComponent', () => {
  let component: ListaExistenciasComponent;
  let fixture: ComponentFixture<ListaExistenciasComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [ListaExistenciasComponent]
    });
    fixture = TestBed.createComponent(ListaExistenciasComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
