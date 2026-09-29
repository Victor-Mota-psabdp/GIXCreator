SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spDIR_SalesForce_Rel]
as
 select 
'Routine' Interface,
'' Ref_Cliente,
''Mensagem,
''Tabela,
DIR,
File_Name,
'br.sao.sistemas@bdpint.com;anderson.oliveira@bdpint.com' [strDestinatario],
'Alert DIR - SF - Financial' [strAssunto],
'Exceeded 500 files' + '||' +
'Diretory : ' + DIR + '|' + 
'Qty Files: ' + File_Name + '|' + 
'|||||||' +'Sent by BDP System' [strCorpoMSG],
NULL,
GETDATE(),
NULL,
NULL,
'' [strAnexoCaminho],
'br.sao.sistemas@bdpint.com' [strResponderPara]   from ATL_INT.dbo.DIR_Routine
where Routine = 'Sales Force' and Dt_Ins >= CAST(GETDATE() as date) and convert(int, FILE_NAME) > =500 and RIGHT(DIR,5) <> 'Void\'
union all
select 
'Routine' Interface,
'' Ref_Cliente,
''Mensagem,
''Tabela,
DIR,
File_Name,
'br.sao.sistemas@bdpint.com;anderson.oliveira@bdpint.com' [strDestinatario],
'Alert DIR - SF - Financial' [strAssunto],
'Exceeded 150 Files' + '||' +
'Diretory : ' + DIR + '|' + 
'Qty Files: ' + File_Name + '|' + 
'|||||||' +'Sent by BDP System' [strCorpoMSG],
NULL,
GETDATE(),
NULL,
NULL,
'' [strAnexoCaminho],
'br.sao.sistemas@bdpint.com' [strResponderPara]   from ATL_INT.dbo.DIR_Routine
where Routine = 'Sales Force' and Dt_Ins >= CAST(GETDATE() as date) and convert(int, FILE_NAME) > =150 and RIGHT(DIR,5) = 'Void\'


GO
