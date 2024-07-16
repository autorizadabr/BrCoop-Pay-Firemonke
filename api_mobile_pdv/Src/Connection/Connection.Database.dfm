object ConnectionDatabase: TConnectionDatabase
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object FDPhysPgDriverLink: TFDPhysPgDriverLink
    Left = 360
    Top = 160
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'Console'
    Left = 96
    Top = 296
  end
  object FDConnection: TFDConnection
    Params.Strings = (
      'ConnectionDef=FDConnection')
    Left = 352
    Top = 344
  end
end
