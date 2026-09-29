SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [dbo].[spTaxasXCodigodeServico_Sel] --'ALL'

@ALL varchar(3)

AS 

select 
	TT.Cd_Tp_Tx		[Codigo da Taxa],
	TT.Nome_Tp_Tx		[Nome da Taxa],
	S.cd_site + ' - '+	s.Nome_Site	[Site],	
	D.cd_servico	[Codigo de Serviço],
	D.Item_lei		[Item Lei],
	D.CNAE			[CNAE],
	D.Descricao		[Descricao]
from Tipo_Taxa TT
	left join Tipo_TaxaXTipo_NF_Doc_Register D on D.Cd_Tp_Tx = TT.Cd_Tp_Tx
	left join Site S on s.Cd_Site = D.cd_site
where
	NF ='S'
	and Desat_Tx = 'N'
Order by [Codigo da Taxa]
GO
