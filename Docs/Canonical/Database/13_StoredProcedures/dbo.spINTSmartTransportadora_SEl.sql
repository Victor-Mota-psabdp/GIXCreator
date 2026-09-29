SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spINTSmartTransportadora_SEl]

		@Num_Proc	Varchar(16)
		
AS



if upper(left(@num_proc,2))='IO'
	Begin
		select 
			Nome_Raz_Soc Transportadora, cd_vendor SCAC 
		from 
			llp_imp_out L with(nolock)
			Join Pessoa P with(nolock) on P.cd_pes=L.cd_transportadora
			Join Pessoa_LLP PL with(nolock) on P.cd_pes=PL.cd_pes
		where 
			Num_Proc_LIO=@Num_PRoc
	End

if upper(left(@num_proc,2))='IM'
	Begin
		select 
			Nome_Raz_Soc Transportadora, cd_vendor SCAC 
		from 
			llp_imp_MAR L with(nolock)
			Join Pessoa P with(nolock) on P.cd_pes=L.cd_transportadora
			Join Pessoa_LLP PL with(nolock) on P.cd_pes=PL.cd_pes
		where 
			Num_Proc_LIM=@Num_PRoc
	End


if upper(left(@num_proc,2))='IA'
	Begin
		select 
			Nome_Raz_Soc Transportadora, cd_vendor SCAC 
		from 
			llp_imp_Aer L with(nolock)
			Join Pessoa P with(nolock) on P.cd_pes=L.cd_transportadora
			Join Pessoa_LLP PL with(nolock) on P.cd_pes=PL.cd_pes
		where 
			Num_Proc_LIA=@Num_PRoc
	End



GO
