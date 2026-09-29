SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spProductCostsTemp_Aut]


AS

	Declare @Cd_Produto int 
	Declare @ALIQ_II float 
	Declare @ALIQ_IPI float
	Declare @VL_ALIQ_PIS float 
	Declare @VL_ALIQ_COFINS float
	Declare @ALIQ_ICMS float
	Declare @Emissao Datetime
	Declare @ID_NF int

declare @Impostos table
	(	
	[Cd_Produto] [int] ,
	[ALIQ_II] [float] ,
	[ALIQ_IPI] [float],
	[VL_ALIQ_PIS] [float] ,
	[VL_ALIQ_COFINS] [float],
	[ALIQ_ICMS] [float],
	[Emissao] Datetime,
	[ID_NF] int
	)

insert into @Impostos	
	select D.Cd_Produto,ALIQ_II,ALIQ_IPI,VL_ALIQ_PIS,VL_ALIQ_COFINS,ALIQ_ICMS,
	MAX(NC.Emissao),
	MAX(NC.ID_NF) from Nota_Fiscal_Cliente_Det D WITH (nolock)
		join Nota_Cliente NC WITH (nolock) ON  NC.CD_Cliente = D.Cd_Cliente and NC.ID_NF  = D.ID_NF
	where isnull(ALIQ_II,0) > 0 and NC.Emissao is not null	
	Group by ALIQ_ICMS,ALIQ_II,ALIQ_IPI,VL_ALIQ_COFINS,VL_ALIQ_PIS,D.Cd_Produto	
	order by Cd_Produto	
	

Declare C_JOBs cursor for
--
		Select [Cd_Produto],[ALIQ_II],[ALIQ_IPI],[VL_ALIQ_PIS],[VL_ALIQ_COFINS],[ALIQ_ICMS],[Emissao],[ID_NF] from @Impostos
		
Open C_JOBs 
SET NOCOUNT ON
Fetch Next From C_JOBS Into @Cd_Produto,@ALIQ_II,@ALIQ_IPI,@VL_ALIQ_PIS,@VL_ALIQ_COFINS,@ALIQ_ICMS,@Emissao,@ID_NF
	While @@FETCH_STATUS = 0
		Begin
			exec spProductCosts_Temp_InsUpd @Cd_Produto,@ALIQ_II,@ALIQ_IPI,@VL_ALIQ_PIS,@VL_ALIQ_COFINS,@ALIQ_ICMS,@Emissao,@ID_NF
							
Fetch Next From C_JOBS Into @Cd_Produto,@ALIQ_II,@ALIQ_IPI,@VL_ALIQ_PIS,@VL_ALIQ_COFINS,@ALIQ_ICMS,@Emissao,@ID_NF
		End
	
close C_JOBS
deallocate C_JOBS

GO
