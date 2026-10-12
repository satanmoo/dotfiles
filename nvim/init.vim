set tabstop=4
set shiftwidth=4
set expandtab

" 입력 모드를 나가면 영문 자판으로 바꾼다. 한글 상태로 노멀 모드에 오면 단축키가 안 먹는다.
if executable('macism')
  autocmd InsertLeave * call jobstart(['macism', 'com.apple.keylayout.ABC'])
endif
