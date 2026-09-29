SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure spATL_ArmadorSemSCAC_Rel
as
select distinct 
	'' Interface,
	'' Ref_Cliente,
	''Mensagem,
	''Tabela,
	'br.sao.sistemas@bdpint.com' [strDestinatario],
	'Alerta - Armadador Sem SCAC' [strAssunto],
	'Nome_Armador - ' + A.Nome_Armador + '|' + 
	'BDP Ref.:		' + isnull(H.Num_Proc,'') + '|' + 
	'|||||||' + 'Sent by BDP System' [strCorpoMSG],
	'' [strAnexoCaminho],
	'br.sao.sistemas@bdpint.com' [strResponderPara] 
from 
	exchange E with(nolock)
join vwHouse_Exp H with(nolock) on E.ExcProcesso = H.Num_Proc
join Armador A with(nolock) on H.Cd_Armador = A.Cd_Armador
where A.Nome_Armador not in ('TO BE CONFIRMED','0') and  A.SCAC is null and E.ExcDataAlt >= GETDATE() -90


GO
