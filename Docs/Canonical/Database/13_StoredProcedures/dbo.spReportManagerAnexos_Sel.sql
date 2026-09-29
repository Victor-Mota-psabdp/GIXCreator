SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE Procedure [dbo].[spReportManagerAnexos_Sel]
		@Num_Proc	Varchar(16)

AS


if left(@Num_Proc,1)='E'
	Begin
		Select 
			dbo.fBuscaDocAnexo(@Num_Proc,20) BL,dbo.fBuscaDocAnexo(@Num_Proc,2) Invoice,dbo.fBuscaDocAnexo(@Num_Proc,4) RE,
			dbo.fBuscaDocAnexo(@Num_Proc,12) DDE,dbo.fBuscaDocAnexo(@Num_Proc,60) PC,dbo.fBuscaDocAnexo(@Num_Proc,10) NF,
			'N/A' DI,'N/A' CI,'N/A' LI,dbo.fBuscaDocAnexo(@Num_Proc,11) PL,dbo.fBuscaDocAnexo(@Num_Proc,16)COA,dbo.fBuscaDocAnexo(@Num_Proc,13) COO,
			'N/A' Capa, dbo.fBuscaDocAnexo(@Num_Proc,44) BL_Original,'N/A' ICMS,'N/A' AFRMM,dbo.fBuscaDocAnexo(@Num_Proc,14) Form_A,
			dbo.fBuscaDocAnexo(@Num_Proc,21) Seguro,dbo.fBuscaDocAnexo(@Num_Proc,22) Fumigacao,dbo.fBuscaDocAnexo(@Num_Proc,27) Arqueacao,
			dbo.fBuscaDocAnexo(@Num_Proc,65) Saque,dbo.fBuscaDocAnexo(@Num_Proc,103) Courier,dbo.fBuscaDocAnexo(@Num_Proc,94) Courier_2
		
			
	
		End
Else
	Begin
		Select 
			dbo.fBuscaDocAnexo(@Num_Proc,20) BL,dbo.fBuscaDocAnexo(@Num_Proc,2) Invoice,'N/A' RE,
			'N/A' DDE,dbo.fBuscaDocAnexo(@Num_Proc,60) PC,dbo.fBuscaDocAnexo(@Num_Proc,10) NF,
			dbo.fBuscaDocAnexo(@Num_Proc,5) DI, dbo.fBuscaDocAnexo(@Num_Proc,6) CI,dbo.fBuscaDocAnexo(@Num_Proc,23) LI,
			dbo.fBuscaDocAnexo(@Num_Proc,11) PL,dbo.fBuscaDocAnexo(@Num_Proc,16)COA,dbo.fBuscaDocAnexo(@Num_Proc,13) COO,
			dbo.fBuscaDocAnexo(@Num_Proc,48) Capa, dbo.fBuscaDocAnexo(@Num_Proc,44) BL_Original,dbo.fBuscaDocAnexo(@Num_Proc,40)  ICMS,dbo.fBuscaDocAnexo(@Num_Proc,41)  AFRMM,
			'N/A' Form_A,
			dbo.fBuscaDocAnexo(@Num_Proc,21) Seguro,dbo.fBuscaDocAnexo(@Num_Proc,22) Fumigacao,dbo.fBuscaDocAnexo(@Num_Proc,27) Arqueacao,
			dbo.fBuscaDocAnexo(@Num_Proc,65) Saque,dbo.fBuscaDocAnexo(@Num_Proc,103) Courier,dbo.fBuscaDocAnexo(@Num_Proc,94) Courier_2



	End
			










GO
