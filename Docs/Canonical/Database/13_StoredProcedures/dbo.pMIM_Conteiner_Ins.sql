SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[pMIM_Conteiner_Ins]
(
@Num_Proc			varchar(14), 
@Item_Cont			varchar(2),
@Cd_Tp_Cont			varchar(3),
@Num_Cont			varchar(15), 
@Num_Lacre			varchar(15)='', 
@Dt_Vcto_Devol		VarChar(10), 
@Dt_Devol			VarChar(10)=Null,
@Lacre_02_IM			Varchar(15)=Null, 
@Peso_Bruto_IM		Float=Null, 
@Tara_IM			Float =Null, 
@Regime_IM			Char(2)=Null, 
@DataDevCli_IM		datetime=null
)
 AS
	Insert Into 
		Container_Mas_Imp_Mar
		(Num_Proc_MIM, Item_Cont_IM, Cd_Tp_Cont, Num_Cont_IM, Num_Lacre_IM, Dt_Vcto_Devol_IM, Dt_Devol_IM, Lacre_02_IM, Peso_Bruto_IM, Tara_IM, DataDevCli_IM)
	Values 
		(@Num_Proc, @Item_Cont, @Cd_Tp_Cont, @Num_Cont, @Num_Lacre, @Dt_Vcto_Devol, @Dt_Devol, @Lacre_02_IM, @Peso_Bruto_IM, @Tara_IM, @DataDevCli_IM)
GO
