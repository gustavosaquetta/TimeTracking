inherited frmTarefas: TfrmTarefas
  Caption = ''
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 718
  ExplicitHeight = 459
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    inherited PageControl1: TPageControl
      inherited tsConsulta: TTabSheet
        ExplicitLeft = 4
        ExplicitTop = 24
        ExplicitWidth = 696
        ExplicitHeight = 322
        inherited cxGrid1: TcxGrid
          inherited cxGrid1DBTableView1: TcxGridDBTableView
            Styles.Content = nil
            Styles.ContentEven = nil
            Styles.ContentOdd = nil
            Styles.Inactive = nil
            Styles.Selection = nil
            Styles.Footer = nil
            Styles.Group = nil
            Styles.GroupByBox = nil
            Styles.Header = nil
            Styles.Indicator = nil
            Styles.Preview = nil
            object cxgrdbclmnI_COD_TAREFA: TcxGridDBColumn
              Caption = 'C'#243'digo'
              Width = 80
            end
            object cxgrdbclmnS_DESCRICAO: TcxGridDBColumn
              Caption = 'Descri'#231#227'o'
              Width = 300
            end
          end
        end
        inherited Panel2: TPanel
          Caption = 'Tarefas'
          inherited Image1: TImage
            Picture.Data = {
              0D546478536D617274496D61676589504E470D0A1A0A0000000D494844520000
              00300000003008060000005702F9870000000473424954080808087C08648800
              0000017352474200AECE1CE90000000467414D410000B18F0BFC610500000009
              7048597300000B0C00000B0C013F4022C800000391494441546843ED994D4F13
              4118C7FB0144317A30267E02AE1CB0AF748BD4802720608D09100F70D0C4140C
              A2248644081CF45285000723087A8000099A50200153C24B480F2094A6DD6D41
              28D006037D1348CBE34C935D172C0ABBB3AD9A6EF2CBCECE64E699FF3CF3B2FB
              AC4C96BAFEC31150A834B54AA5A69B8F4AA579F44F48CDC9C95166143F095C31
              8E029F8CA25ABF56AB95FF3522140A75874AAD1D3D4E9652D397F67436243301
              F039573319B88ECAE2D541DE69935418A5566B753A5D364B764EDED78BCFADD1
              4BF5B3709CCBCFA640D6863A1F075C16AF4E7ABD35A2BE71D3CDB7A1D168B245
              8BCACCCCBCA6CFCDF557565478CB4A4BB731DAFC8248DA4B27C8DEA04E12E4C2
              0B3B686F1544583B15C8A65EAFDF91CBE557050B412362B62DD9201289C678D8
              6882F3AF199075A3CE4B40BAC901C6E616CEDEE2E222A03E7C1223C041D34CAC
              C1CDCD2D28B95F03FADBE5926278F018B6B6BC319BB4D30968E1DB8908C00D86
              C3DFC1E3D990146C83F53871016CC389BAA704A005C4AD81448D3ADF0E710FCC
              CCCCC22B9389C3B6B4047B7BFBE0F5FA88110804A55B039D6F3B4147511CC3C3
              6670381C70C76020C640FF4062054839B5884C218661201A8DC6E8EA3CEA01B3
              D90CABABAB5057572798BEDE5EAE7DD60E7B272E607D7D1DE6E6E6387C5E2F04
              02812379FCF2D3A4699A965A800B19384C0AB493167F12334C4A8060EF11F740
              2F5A7025C5C51C9F2726607BFB1B0C0E0E0AC66AB59E2890B88078BB107E4B6D
              6D6915CCD8D858720548B9C0897BA0A7A707F2F3F238F0E82D2FDB8FE4F1CBF9
              E9F2B2B233AF0522025C2E171C1E1E2605069D11A23F68520244788FB8077C3E
              1F2CDB6C1C3B3B3B924E2DE202E26DA32B2B2B505D5D7D26EC76FBA984274440
              301884F9F9F933E1F7FBFF1E01BBBBBB303E3E2E181B9A9227ED72843CE04606
              2086C53209CD4D4D1C0B0B5F6221167EDE59D343431FB9F6593BEC9D41312902
              DBE84F01C70D48FD9C1280C32A6EB71B9275B9D0E7ACE829C417805F7D3BDADB
              397044027FBF86C36141E0BABFBB880B78D7D57524AC323232024E24A2A8B050
              10B883491720E5F44A88073C1E0F3436348826140AFD3216C405E01890C562E1
              F0A2B00A3E55F97942D3070707D20B9072BAC46B5BB40772296A6A636323D1FD
              E6ECADADAD01455116C17F68D00FB6CA2AA3717F7A7A1A70042291609B555555
              7B8AACAC7B8205E08AE877E75D74987CC856ABFB13CC7BA5526910D5F954E5D4
              08FC79047E00D80AB2227A105E8B0000000049454E44AE426082}
          end
        end
      end
      inherited tsCadastro: TTabSheet
        ExplicitLeft = 4
        ExplicitTop = 24
        ExplicitWidth = 696
        ExplicitHeight = 322
        object lbl1: TLabel [0]
          Left = 16
          Top = 166
          Width = 50
          Height = 13
          Caption = 'Descri'#231#227'o:'
        end
        object lbl2: TLabel [1]
          Left = 16
          Top = 112
          Width = 41
          Height = 13
          Caption = 'Situa'#231#227'o'
        end
        object lbl3: TLabel [2]
          Left = 256
          Top = 112
          Width = 36
          Height = 13
          Caption = 'Usu'#225'rio'
        end
        inherited Panel3: TPanel
          Caption = 'Tarefas'
          inherited Image2: TImage
            Picture.Data = {
              0D546478536D617274496D61676589504E470D0A1A0A0000000D494844520000
              00300000003008060000005702F9870000000473424954080808087C08648800
              0000017352474200AECE1CE90000000467414D410000B18F0BFC610500000009
              7048597300000B0C00000B0C013F4022C800000391494441546843ED994D4F13
              4118C7FB0144317A30267E02AE1CB0AF748BD4802720608D09100F70D0C4140C
              A2248644081CF45285000723087A8000099A50200153C24B480F2094A6DD6D41
              28D006037D1348CBE34C935D172C0ABBB3AD9A6EF2CBCECE64E699FF3CF3B2FB
              AC4C96BAFEC31150A834B54AA5A69B8F4AA579F44F48CDC9C95166143F095C31
              8E029F8CA25ABF56AB95FF3522140A75874AAD1D3D4E9652D397F67436243301
              F039573319B88ECAE2D541DE69935418A5566B753A5D364B764EDED78BCFADD1
              4BF5B3709CCBCFA640D6863A1F075C16AF4E7ABD35A2BE71D3CDB7A1D168B245
              8BCACCCCBCA6CFCDF557565478CB4A4BB731DAFC8248DA4B27C8DEA04E12E4C2
              0B3B686F1544583B15C8A65EAFDF91CBE557050B412362B62DD9201289C678D8
              6882F3AF199075A3CE4B40BAC901C6E616CEDEE2E222A03E7C1223C041D34CAC
              C1CDCD2D28B95F03FADBE5926278F018B6B6BC319BB4D30968E1DB8908C00D86
              C3DFC1E3D990146C83F53871016CC389BAA704A005C4AD81448D3ADF0E710FCC
              CCCCC22B9389C3B6B4047B7BFBE0F5FA88110804A55B039D6F3B4147511CC3C3
              6670381C70C76020C640FF4062054839B5884C218661201A8DC6E8EA3CEA01B3
              D90CABABAB5057572798BEDE5EAE7DD60E7B272E607D7D1DE6E6E6387C5E2F04
              02812379FCF2D3A4699A965A800B19384C0AB493167F12334C4A8060EF11F740
              2F5A7025C5C51C9F2726607BFB1B0C0E0E0AC66AB59E2890B88078BB107E4B6D
              6D6915CCD8D858720548B9C0897BA0A7A707F2F3F238F0E82D2FDB8FE4F1CBF9
              E9F2B2B233AF0522025C2E171C1E1E2605069D11A23F68520244788FB8077C3E
              1F2CDB6C1C3B3B3B924E2DE202E26DA32B2B2B505D5D7D26EC76FBA984274440
              301884F9F9F933E1F7FBFF1E01BBBBBB303E3E2E181B9A9227ED72843CE04606
              2086C53209CD4D4D1C0B0B5F6221167EDE59D343431FB9F6593BEC9D41312902
              DBE84F01C70D48FD9C1280C32A6EB71B9275B9D0E7ACE829C417805F7D3BDADB
              397044027FBF86C36141E0BABFBB880B78D7D57524AC323232024E24A2A8B050
              10B883491720E5F44A88073C1E0F3436348826140AFD3216C405E01890C562E1
              F0A2B00A3E55F97942D3070707D20B9072BAC46B5BB40772296A6A636323D1FD
              E6ECADADAD01455116C17F68D00FB6CA2AA3717F7A7A1A70042291609B555555
              7B8AACAC7B8205E08AE877E75D74987CC856ABFB13CC7BA5526910D5F954E5D4
              08FC79047E00D80AB2227A105E8B0000000049454E44AE426082}
          end
        end
        object I_COD_TAREFA: TLabeledEdit
          Left = 16
          Top = 72
          Width = 121
          Height = 21
          EditLabel.Width = 85
          EditLabel.Height = 13
          EditLabel.Caption = 'C'#243'digo da tarefa:'
          Enabled = False
          TabOrder = 1
        end
        object S_DESCRICAO: TMemo
          Left = 16
          Top = 185
          Width = 657
          Height = 89
          ScrollBars = ssVertical
          TabOrder = 7
        end
        object I_ESTIMATIVA: TLabeledEdit
          Left = 160
          Top = 128
          Width = 72
          Height = 21
          EditLabel.Width = 53
          EditLabel.Height = 13
          EditLabel.Caption = 'Estimativa:'
          TabOrder = 4
        end
        object I_COD_USUARIO: TDBLookupComboBox
          Left = 256
          Top = 128
          Width = 145
          Height = 21
          KeyField = 'I_COD_USUARIO'
          ListField = 'S_NOME'
          ListSource = dsUsuario
          TabOrder = 5
        end
        object S_NOME: TLabeledEdit
          Left = 160
          Top = 72
          Width = 385
          Height = 21
          CharCase = ecUpperCase
          EditLabel.Width = 27
          EditLabel.Height = 13
          EditLabel.Caption = 'Nome'
          TabOrder = 2
        end
        object I_COD_SITUACAO: TDBLookupComboBox
          Left = 16
          Top = 128
          Width = 121
          Height = 21
          KeyField = 'I_COD_SITUACAO'
          ListField = 'S_NOME'
          ListSource = dsSituacao
          TabOrder = 3
        end
        object S_VERSAO: TLabeledEdit
          Left = 424
          Top = 128
          Width = 121
          Height = 21
          EditLabel.Width = 33
          EditLabel.Height = 13
          EditLabel.Caption = 'Vers'#227'o'
          TabOrder = 6
        end
      end
    end
  end
  inherited cxImageList1: TcxImageList
    FormatVersion = 1
    DesignInfo = 456
  end
  inherited dsConsulta: TDataSource
    Left = 520
  end
  inherited ActionList1: TActionList
    Left = 398
    inherited actExcluir: TAction
      OnExecute = actExcluirExecute
    end
  end
  inherited cxstylrpstry1: TcxStyleRepository
    Left = 574
    Top = 0
    PixelsPerInch = 96
    inherited cxgrdtblvwstylshtGridTableViewStyleSheetRainyDay: TcxGridTableViewStyleSheet
      BuiltIn = True
    end
  end
  object dsUsuario: TDataSource
    Left = 630
  end
  object dsSituacao: TDataSource
    Left = 672
  end
end
