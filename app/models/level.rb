class Level < ActiveRecord::Base
  belongs_to :admin

  $monds_controller = "monds"
  $personals        = "personals"
  $tabels           = "tabels"
  $comments         = "comments"
  $format_time      = "time"             # access to отработанное время
  $format_tabel     =  "tabel"           # access to начисление
  $format_buchtabel =  "buchtabel"       # access to ведомость
  $format_unknown   =  "---"

  #$controller = [$monds, $personals, $tabels, $comments]
  $controller_select  = [["Месяцы", $monds_controller],["Персонал",$personals],["Ведомость",$tabels],["Отзывы",$comments]]

  $controller_show  = [{'controller'=>$monds_controller,'name'=>'Месяцы'},{'controller'=>$personals,'name'=>'Персонал'},
                       {'controller'=>$tabels,'name'=>'Ведомость'},{'controller'=>$comments,'name'=>'Отзывы'}]

  $level_index_controller = {$monds_controller => 'Месяцы', $personals => 'Персонал', $comments => 'Отзывы', $tabels => 'Ведомость'}

  $level_format    = {$format_time => 'Доступ к табелю', $format_tabel=> 'Доступ к начислению',$format_buchtabel => 'Доступ к ведомости'}
  $format_select    = [[" ",""], ["Доступ к табелю", $format_time], ["Доступ к начислению",$format_tabel],
                       ["Доступ к ведомости",$format_buchtabel]]
  $level_action     = {}

  $access_denied = "У Вас нет доступа!"     # индикатор запрета
  $access_action = "Access!"
  $denied_action  = "Access denied!"
  # блокировка таблиц
  $access_select =[[$denied_action, 0],[$access_action, 1]]
  $access_show = [$denied_action, $access_action]
  # создание новых таблиц доступа к страницам
  $create_levels  = [$monds_controller,$personals,$comments]
  # создание новых таблиц доступа к страницам tabels
  $create_levels_tabels = [$format_time, $format_tabel,$format_buchtabel]




end
