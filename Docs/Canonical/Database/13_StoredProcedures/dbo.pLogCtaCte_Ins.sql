SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/****** Object:  Stored Procedure dbo.pLogCtaCte_Ins    Script Date: 17/10/2002 07:32:50 ******/
CREATE PROCEDURE [dbo].[pLogCtaCte_Ins]
(
@Tipo				Char(1), 
@Num_Proc_HEM		varchar(16), 
@Cd_Tp_Tx			varchar(3),
@DC_HEM			char(1),
@Org_Ins_HEM			varchar(9),
@Dt_Ins_HEM			varchar(10), 
@Cd_Tp_Moeda		varchar(3), 
@Vlr_Org_HEM			decimal, 
@Dt_Prev_Pgto_HEM		varchar(10), 
@Cd_Cred_Dev_HEM		varchar(10), 
@Desp_Dst_HEM		char(1),
@CPMF_HEM			char(1), 
@Comp_RP_HEM		char(1), 
@Comp_DN_HEM		char(1),
@Comp_CN_HEM		char(1),
@Comp_CPA_HEM		char(1), 
@Usuario			Varchar(50),
@Vlr_Contab			decimal(12,2)=null 
)
 AS

Declare @usuarioN varchar(6)

if len(@usuario)<6 
	Begin
		Set @usuarioN=@usuario
	End
Else
	Begin
		Set @usuarioN=(select cd_usuario from usuario where nome_usuario=@usuario)
	End	


	Insert into 
		Log_Cta_Cte 
		(Data_CC, Cd_Usuario, Tp_Oper_CC, Num_Proc_CC, Cd_Tp_Tx, DC_CC, Org_Ins,Dt_Ins, Cd_Tp_Moeda, 
		 Vlr_Org, Dt_Prev_Pgto, Cd_Cred_Dev, Desp_Org_Dst, CPMF, Comp_RP, Comp_DN, Comp_CN, Comp_CPA, Vlr_Contab) 
	Values 
		( GetDate(), @usuarioN, @Tipo, @Num_Proc_HEM, @Cd_Tp_Tx,@DC_HEM, @Org_Ins_HEM,@Dt_Ins_HEM, @Cd_Tp_Moeda, 
		@Vlr_Org_HEM, @Dt_Prev_Pgto_HEM,@Cd_Cred_Dev_HEM, @Desp_Dst_HEM,@CPMF_HEM,@Comp_RP_HEM, 
		@Comp_DN_HEM, @Comp_CN_HEM, @Comp_CPA_HEM, @Vlr_Contab)

GO
