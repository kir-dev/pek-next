var judgement = (function(Helpers) {
  var module = {};

  module.init = function() {
    Helpers.initSwitcher('evaluation-tab');
    const table = $('#points-table');
    const list = $('#name-list');
    if (!table || !list) { return; }

    initSortTable(table, list);
  }

  function initSortTable(table, list) {
    $('.sortable-column').each(function(){
      const th = $(this);
      const thIndex = th.index();
      var inverse = false;
      initHeader(th);

      th.click(function(){
        table.find('tbody td').filter(function(){
          return $(this).index() === thIndex;
        }).sortElements(comparatorFactory(inverse), function(){
          return this.parentNode;
        });
        updateNameList(list, table);
        inverse = !inverse;
      });
    });
  }

  function comparatorFactory(inverse) {
    return function(a, b) {
      a = a.innerText;
      b = b.innerText;
      if (a === b) { return 0; }
      if (a != '' && b != '') {
        a = Number(a);
        b = Number(b);
      }
      return a > b ? (inverse ? -1 : 1) : (inverse ? 1 : -1);
    }
  }

  function updateNameList(list, table) {
    const newList = document.createElement('ul');
    table.find('tbody tr').each(function(){
      newList.appendChild(
        list.find('[data-user="' + this.getAttribute('data-user') + '"]').get(0)
      );
    });
    newList.innerHTML += '<li>Összegzések:</li>';
    list[0].innerHTML = newList.innerHTML;
  }

  function initHeader(th) {
    th.attr('uk-tooltip', '');
    th.attr('title', 'Rendezés');
    th.on('selectstart', function() { return false; });
  }

  return module;
}(Helpers));

$(document).ready(judgement.init);
