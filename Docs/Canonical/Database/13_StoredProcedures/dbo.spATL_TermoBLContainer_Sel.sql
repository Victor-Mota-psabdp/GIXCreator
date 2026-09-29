SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alter table [dbo].[Container_Avaria] add [Nome_Armador] [varchar](200) NULL
--spATL_TermoBLContainer_Sel 'IMUPL201508082BR','NL1005247744','MEDU400854-8','A'
CREATE PROCEDURE [dbo].[spATL_TermoBLContainer_Sel] 
(
	@ID		int,
	@Termo	varchar(1)
)
AS
	select 
		T.Codigo			[Código],
		T.Num_Proc		[Job],
		T.BL				[BL],
		T.Container		[Container],
		T.Desc_Lavagem	[Descrição Lavagem],
		T.Valor_Termo		[Valor Termo],
		T.Qty_Avaria		[Quantidade Avaria],
		T.Desc_Avaria		[Descrição Avaria],
		T.Qty_Avaria_2	[Quantidade Avaria 2],
		T.Desc_Avaria_2	[Descrição Avaria 2],
		T.Qty_Avaria_3	[Quantidade Avaria 3],
		T.Desc_Avaria_3	[Descrição Avaria 3],
		ISNULL(T.nome_armador,A.Nome_Armador) Nome_Armador,
		ISNULL(T.Taxa_Indisponibilidade_Container,'USD 150,00 para unidades DRY e USD 350,00 para unidades Reefer') Taxa_Indisponibilidade_Container
	from Container_Avaria T
		left join vwHouse_Imp	I	with(nolock) on I.Num_Proc = T.Num_Proc
		left join Armador		A	with(nolock) on a.Cd_Armador = I.Cd_Armador
	where 
		T.Codigo = @ID
		and T.Tp_Termo = @Termo

 
  
 
 
 
 
 
 


GO
