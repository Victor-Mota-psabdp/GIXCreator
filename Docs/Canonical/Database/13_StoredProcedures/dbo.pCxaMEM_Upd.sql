SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCxaMEM_Upd    Script Date: 17/10/2002 07:32:48 ******/
CREATE PROCEDURE pCxaMEM_Upd
(
@Num_Proc_MEM		varchar(16),
@Cd_Tp_Tx			varchar(3),
@DC_MEM			char(1),
@Num_Lcto			varchar(12), 
@Vlr_Ref_MEM			float,
@Dt_Conv_MEM		varchar(10), 
@Cd_Tp_Par			varchar(3), 
@Par_Moeda_MEM		float,
@Vlr_Pgto_Rcto_MEM		float,
@Num_Rcb_MEM		varchar(12),
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
	Set @NumRec = IsNull((Select Num_Rcb_MEM From Caixa_Mas_Exp_Mar Where Num_Proc_MEM = @Num_Proc_MEM and Cd_Tp_Tx = @Cd_Tp_Tx and DC_MEM = @DC_MEM),'')
	If @NumRec <>  'RM'
		Begin 
			Update 
				Caixa_Mas_Exp_Mar
			Set 
				Vlr_Ref_MEM=@Vlr_Ref_MEM,
				Dt_Conv_MEM=@Dt_Conv_MEM,
				Cd_Tp_Par=@Cd_Tp_Par,
				Par_Moeda_MEM=@Par_Moeda_MEM,
				Vlr_Pgto_Rcto_MEM=@Vlr_Pgto_Rcto_MEM,
				Num_Rcb_MEM=@Num_Rcb_MEM
			Where 
				Num_Proc_MEM = @Num_Proc_MEM and 
				Cd_Tp_Tx = @Cd_Tp_Tx and 
				DC_MEM = @DC_MEM and 
				Num_Lcto=@Num_Lcto
			If @@RowCount = 1 
				Begin 
					Exec pLogCaixa_Ins
						'I', @Num_Proc_MEM, @Cd_Tp_Tx, @DC_MEM, @Num_Lcto, @Vlr_Ref_MEM, @Dt_Conv_MEM, @Cd_Tp_Par, @Par_Moeda_MEM,
						@Vlr_Pgto_Rcto_MEM,Null, @Num_Rcb_MEM, @Usuario
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
