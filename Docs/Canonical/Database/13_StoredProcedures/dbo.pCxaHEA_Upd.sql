SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[pCxaHEA_Upd]
(
@Num_Proc_HEA		varchar(16),
@Cd_Tp_Tx			varchar(3),
@DC_HEA			char(1),
@Num_Lcto			varchar(12), 
@Vlr_Ref_HEA			float,
@Dt_Conv_HEA		varchar(10), 
@Cd_Tp_Par			varchar(3), 
@Par_Moeda_HEA		float,
@Vlr_Pgto_Rcto_HEA		float,
@Num_Rcb_HEA		varchar(12),
@Usuario			Varchar(6)
)
--Parâmetros de Retorno 
--(1) Procedimento concluído com exito 
--(-2) Erro no Procedimento 
--(-3) Erro na Inserção do Log 
--(-4) Processo de Remessa
 AS
	Declare @NumRec VarChar(12) 
	
	
	Begin Transaction 
	Set @NumRec = IsNull((Select Num_Rcb_HEA From Caixa_Hou_Exp_Aer Where Num_Proc_HEA = @Num_Proc_HEA and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HEA = @DC_HEA),'')
	If @NumRec <>  'RA'
		Begin
			Update 
				Caixa_Hou_Exp_Aer
			Set 
				Vlr_Ref_HEA=@Vlr_Ref_HEA,
				Dt_Conv_HEA=@Dt_Conv_HEA,
				Cd_Tp_Par=@Cd_Tp_Par,
				Par_Moeda_HEA=@Par_Moeda_HEA,
				Vlr_Pgto_Rcto_HEA=@Vlr_Pgto_Rcto_HEA,
				Num_Rcb_HEA=@Num_Rcb_HEA
			Where 
				Num_Proc_HEA = @Num_Proc_HEA and 
				Cd_Tp_Tx = @Cd_Tp_Tx and 
				DC_HEA = @DC_HEA and 
				Num_Lcto=@Num_Lcto
			If @@RowCount = 1 
				Begin 
					Exec pLogCaixa_Ins
						'I', @Num_Proc_HEA, @Cd_Tp_Tx, @DC_HEA, @Num_Lcto, @Vlr_Ref_HEA, @Dt_Conv_HEA, @Cd_Tp_Par, @Par_Moeda_HEA,
						@Vlr_Pgto_Rcto_HEA,Null, @Num_Rcb_HEA, @Usuario
					If @@RowCount = 1 
						Begin 
							Commit Transaction 
							Return 1 
						End 
					Else 
						Begin 
							Rollback Transaction 
							Return -3 
						End 
				End 
			Else
				Begin 
					RollBack Transaction 
					Return -2
				End 
		End 
	Else 
		Begin 
			RollBack Transaction
			Return -4 
		End




GO
