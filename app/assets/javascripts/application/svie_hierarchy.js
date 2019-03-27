const svieHierarchy = (function() {
  var module = {};
  var hierarchyTree = null;

  function toggleDisplay(element) {
    if (element.style.display === 'block') {
      element.style.display = 'none';
    } else {
      element.style.display = 'block';
    }
  }

  function toggleBranch(event) {
    const branch = event.target;
    const icons = branch.getElementsByTagName('i');
    const subBranches = branch.getElementsByTagName('ul');

    if (subBranches.length > 1) {
      toggleDisplay(subBranches[0]);
      toggleIcons(icons[0], icons[1]);
    }
  }

  function toggleIcons(downIcon, upIcon) {
    if (downIcon.classList.contains('uk-hidden')) {
      upIcon.classList.add('uk-hidden');
      downIcon.classList.remove('uk-hidden');
    } else {
      upIcon.classList.remove('uk-hidden');
      downIcon.classList.add('uk-hidden');
    }
  }

  function addLinksToBranches(parent) {
    const branches = parent.getElementsByTagName('li');

    for (var i=0; i < branches.length; i++) {
      var subBranches = branches[i].getElementsByTagName('ul');
      if (subBranches.length > 1) {
        addLinksToBranches(subBranches[0]);
        branches[i].className = 'hierarchy-link';
      } else {
        branches[i].className = 'hierarchy-item';
      }
    }
  }

  module.init = function() {
    hierarchyTree = document.getElementById('hierarchy-tree');
    if (!hierarchyTree) { return; }

    const subList = hierarchyTree.getElementsByTagName('ul');
    for (var i=0; i < subList.length; i++) {
      subList[i].style.display = 'none';
    }

    hierarchyTree.addEventListener('click', toggleBranch, false);
    addLinksToBranches(hierarchyTree);
  }

  return module;
}());

$(document).ready(svieHierarchy.init);
