SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_TermoContainer_Sel 'IMUPL201508082BR','MEDU400854-8','A'
CREATE  PROCEDURE [dbo].[spATL_TermoContainer_Sel] 
(
	@Job	varchar(16),
	@Container		varchar(15),
	@Termo			varchar(1)
)
AS

if @Termo = 'A'
	select
		T.Codigo		[Código],
		T.Num_Proc	[Job],
		T.BL			[BL],
		T.Container	[Container],
		T.Qty_Avaria	[Quantidade Avaria],
		T.Desc_Avaria [Descrição Avaria],
		T.Qty_Avaria_2	[Quantidade Avaria 2],
		T.Desc_Avaria_2 [Descrição Avaria 2],
		T.Qty_Avaria_3	[Quantidade Avaria 3],
		T.Desc_Avaria_3 [Descrição Avaria 3],
		ISNULL(T.nome_armador,A.Nome_Armador) Nome_Armador,
		ISNULL(T.Taxa_Indisponibilidade_Container,'USD 150,00 para unidades DRY e USD 350,00 para unidades Reefer') Taxa_Indisponibilidade_Container
	from 
		Container_Avaria T
		left join vwHouse_Imp	I	with(nolock) on I.Num_Proc = T.Num_Proc
		left join Armador		A	with(nolock) on a.Cd_Armador = I.Cd_Armador
	where 
		T.Num_Proc like @Job 
		and T.Container like @Container
		and T.Tp_Termo = @Termo
else
	select 
		T.Codigo			[Código],
		T.Num_Proc		[Job],
		T.BL				[BL],
		T.Container		[Container],
		T.Desc_Lavagem	[Descrição Lavagem],
		T.Valor_Termo		[Valor],
		ISNULL(T.nome_armador,A.Nome_Armador) Nome_Armador,
		ISNULL(T.Taxa_Indisponibilidade_Container,'USD 150,00 para unidades DRY e USD 350,00 para unidades Reefer') Taxa_Indisponibilidade_Container
	from 
		Container_Avaria T
		left join vwHouse_Imp	I	with(nolock) on I.Num_Proc = T.Num_Proc
		left join Armador		A	with(nolock) on a.Cd_Armador = I.Cd_Armador
	where 
		T.Num_Proc like @Job 
		and T.Container like @Container
		and T.Tp_Termo = @Termo
	

 
  
 
 
 
 
 
 


GO
