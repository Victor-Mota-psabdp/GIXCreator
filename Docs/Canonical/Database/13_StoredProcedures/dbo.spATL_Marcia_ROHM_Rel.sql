SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spATL_Marcia_ROHM_Rel] 
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime,
	@Type	varchar(1)
as
	declare @cd_pes_grupo varchar(10)
	Set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)

	select
		LLP.num_proc_LIM					[BDP Ref.],
		ATA_LIM								[ATA],
		peso_liquido_him					[Net Weight],
		peso_bruto_him						[Gross Weight],
		'Maritimo'							[Modal]		
	from
		LLP_Imp_Mar LLP with(nolock)
		Join House_Imp_Mar HOU with(nolock) on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIM and PLL.Cd_Pes_Grupo=@cd_pes_grupo		
	where
		ATA_LIM  between @DtInicial and @DtFinal

order by 2
GO
