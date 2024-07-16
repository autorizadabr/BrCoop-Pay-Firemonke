object ModelConnection: TModelConnection
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 480
  Width = 640
  object FConnection: TFDConnection
    Params.Strings = (
      
        'Database=C:\WkTechnology\Fabrica-Concordia-Controle_de_Ponto_Mob' +
        'ile\scr\DB\ConcordiaMobile'
      'OpenMode=ReadWrite'
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    AfterConnect = FConnectionAfterConnect
    Left = 256
    Top = 248
  end
end
