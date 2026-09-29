SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCxaHEM_Del    Script Date: 17/10/2002 07:32:48 ******/
CREATE PROCEDURE pCxaHEM_Del
(
@Num_Proc_HEM		varchar(16),
@Cd_Tp_Tx			varchar(3),
@DC_HEM			char(1),
@Num_Lcto			varchar(12), 
@Vlr_Ref_HEM			float,
@Dt_Conv_HEM		varchar(10), 
@Cd_Tp_Par			varchar(3), 
@Par_Moeda_HEM		float,
@Vlr_Pgto_Rcto_HEM		float,
@Num_Rcb_HEM		varchar(12),
@Usuario			Varchar(6)
)
--Parâmetros de Retorno 
--(1) Procedimento concluído com exito 
--(-1) Violação de Chave 
--(-2) Erro no Procedimento 
--(-3) Erro na Inserção do Log 
--(-4) Processo de Remessa
 AS
	Declare @NumRec VarChar(12) 
	Begin Transaction 
	Set @NumRec = IsNull((Select Distinct Num_Rcb_HEM From Caixa_Hou_Exp_Mar Where Num_Proc_HEM = @Num_Proc_HEM and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HEm = @DC_HEM),'')
	If @NumRec <>  'RM'
		Begin 
			Delete From 
				Caixa_Hou_Exp_Mar
			Where 
				Num_Proc_HEM = @Num_Proc_HEM and 
				Cd_Tp_Tx = @Cd_Tp_Tx and 
				DC_HEM = @DC_HEM and 
				Num_Lcto = @Num_Lcto
			If @@RowCount = 1 
				Begin 
					Exec pLogCaixa_Ins
						'E', @Num_Proc_HEM, @Cd_Tp_Tx, @DC_HEM, @Num_Lcto, @Vlr_Ref_HEM, @Dt_Conv_HEM, @Cd_Tp_Par, @Par_Moeda_HEM,
						@Vlr_Pgto_Rcto_HEM, Null, @Num_Rcb_HEM, @Usuario
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
					Return -1
				End
		End 
	Else	
		Begin 
			RollBack Transaction
		Return - 4	
			End

GO
