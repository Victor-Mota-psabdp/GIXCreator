SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[spDeclaracao_Origem_Rel]'Grupo Dow','2017-12-01','2017-12-31'

--select * from Produto_Cliente where cd_Proc_Cliente ='10092341'
--select * from DE_PARA_PRODUTO where gmid ='10092341'
CREATE procedure [dbo].[spDeclaracao_Origem_Rel]
(
	@Grupo varchar(20)
)

as	

	--declare @Grupo varchar(20)
	--set @Grupo = 'Grupo Dow'
	declare @cd_pes_grupo varchar(10)
	Set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa With(nolock) where apelido=@Grupo)
	
	select 
		PC.cd_Proc_Cliente									[Product ID],
		PC.Produto_Descr									[Product Description],
		Business_Group_Descr								[Business Group],
		--isnull([dbo].[fBusca_GMID_Business_Group](HOU.Num_Proc),'') [Business Group],
		Business_Descr										[Business Name],
		--isnull([dbo].[fBusca_GMID_Business_Descr](HOU.Num_Proc),'') [Business Name],
		CPC3.CAMPO_DADOS									[Responsável/Dow pelo envio da declaração à BDP],
		CPC4.CAMPO_DADOS									[Data de Envio da revisão p/ Dow],
		CPC5.CAMPO_DADOS									[Data de Aprovação/Recebimento da Dow],
		CPC6.CAMPO_DADOS									[Data envio da Declaração a Associação/Fiesp],
		CPC7.CAMPO_DADOS									[Número do Registro de Declaração de Origem],
		CPC8.CAMPO_DADOS									[Data de Vencimento de Declaração de Produto],
		(case when CPC9.CAMPO_DADOS = '1' then 'Sim' else 'Não'	end)								[Atende o Requisito Sim/Não],
		--CPC10.CAMPO_DADOS									[ITO Responsável],
		TIS.NOME_TP_ITO_Specialist							[ITO Responsável],
		CPC12.CAMPO_DADOS									[Comentários]	
from Produto_Cliente			PC	with(nolock)	
	Left join DE_PARA_PRODUTO	DPP with(nolock) on PC.cd_Proc_Cliente = DPP.GMID and DPP.cd_cliente = @cd_pes_grupo
	and Trade_Product_Descr is not null
	left join Campo_Produto_Cliente CPC3   with(nolock) on CPC3.cd_prod =PC.cd_prod AND CPC3.ID_CAMPO = '3'
	left join Campo_Produto_Cliente CPC4   with(nolock) on CPC4.cd_prod =PC.cd_prod AND CPC4.ID_CAMPO = '4'
	left join Campo_Produto_Cliente CPC5   with(nolock) on CPC5.cd_prod =PC.cd_prod AND CPC5.ID_CAMPO = '5'
	left join Campo_Produto_Cliente CPC6   with(nolock) on CPC6.cd_prod =PC.cd_prod AND CPC6.ID_CAMPO = '6'
	left join Campo_Produto_Cliente CPC7   with(nolock) on CPC7.cd_prod =PC.cd_prod AND CPC7.ID_CAMPO = '7'
	left join Campo_Produto_Cliente CPC8   with(nolock) on CPC8.cd_prod =PC.cd_prod AND CPC8.ID_CAMPO = '8'
	left join Campo_Produto_Cliente CPC9   with(nolock) on CPC9.cd_prod =PC.cd_prod AND CPC9.ID_CAMPO = '9'
	
	left join Campo_Produto_Cliente CPC11  with(nolock) on CPC11.cd_prod =PC.cd_prod AND CPC11.ID_CAMPO = '11'	
	left join Campo_Produto_Cliente CPC12  with(nolock) on CPC12.cd_prod =PC.cd_prod AND CPC12.ID_CAMPO = '12'	
	left join Campo_Produto_Cliente CPC10  with(nolock) on CPC10.cd_prod =PC.cd_prod AND CPC10.ID_CAMPO = '10'
	left join tipo_ito_specialist TIS	 with(nolock) on tis.ID_TP_ITO_Specialist = CPC10.Campo_Dados
where
	CPC11.CAMPO_DADOS = '1'
	and PC.cd_cliente = @cd_pes_grupo
	--and GMID = '10253357'


GO
