SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spSF_Accounts_Sel]

as

select 
'' Interface,
'' Ref_Cliente,
''Mensagem,
''Tabela,
P.Cd_Pes,
PA.Cd_AX,
PA.Tipo,
'br.sao.sistemas@bdpint.com' [strDestinatario],
'Alerta - SF - Accounts' [strAssunto],
'Company Code ATL : ' + P.Cd_Pes + '|' + 
'Company Name ATL : ' + P.Apelido + '|' + 
'Company Code AX : ' + cast(PA.Cd_AX as varchar(50)) + '|' + 
'Type AX : ' + PA.Tipo + '|' + 
'|||||||' +'Sent by BDP System' [strCorpoMSG],
NULL,
GETDATE(),
NULL,
NULL,
'' [strAnexoCaminho],
'br.sao.sistemas@bdpint.com' [strResponderPara]  
from Pessoa P with(nolock)
left join Account_SFDC A with(nolock) on P.Cd_Pes = A.Cd_Pes 
join Pessoa_ATL_AX PA with(nolock) on P.Cd_Pes = PA.Cd_Pes
join vwcta_Cte cc with(nolock) on cc.Cd_Cred_Dev_HIA = P.Cd_Pes
where convert(datetime,Dt_Cad,103) >= '2015-01-01' and A.Cd_Pes is null and Cd_Usuario = 'ATL' and RIGHT(Apelido,1) in ('C','V')
option(hash join)
GO
