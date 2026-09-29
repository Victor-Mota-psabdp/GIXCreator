SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCxaHIA_Sel    Script Date: 17/10/2002 07:32:48 ******/
CREATE PROCEDURE pCxaHIA_Sel 
(
@Num_Proc_HIA	VarChar(16),
@Cd_Tp_Tx		VarChar(3), 
@DC_HIA		Char(1),
@SelReciboNull		Char(1)= '',   -- Informar 'S' para Seleção de Registros c/ Recibo = '' 
@Detalhe		Char(1)=''
)
 AS
	If @SelReciboNull = ''
		Begin
			If @Detalhe = ''
				Select 
					*
				From 
					Caixa_Hou_Imp_Aer
				Where 	
					Num_Proc_HIA = @Num_Proc_HIA  AND 
					Cd_Tp_Tx = @Cd_Tp_Tx AND 
					DC_HIA = @DC_HIA
				Order by 
					Num_Lcto
			Else
				Select 
					Num_Rcb_HIA, Nome_Tp_Tx, Cxa.DC_HIA, Num_Lcto, Nome_Tp_Moeda, 
					Vlr_Ref_HIA, Dt_Conv_HIA, Nome_Tp_Par, Par_Moeda_HIA, Vlr_Pgto_Rcto_HIA, 
					Dt_Pgto_Rcto_HIA, Dt_Ctb_Cx_HIA 
				From 
					Cta_Cte_Hou_Imp_Aer as Cta  Join Caixa_Hou_Imp_Aer as Cxa on (Cta.Num_Proc_HIA = Cxa.Num_Proc_HIA and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HIA = Cxa.DC_HIA)
					Join Tipo_Taxa as TT  on Cxa.Cd_Tp_Tx = TT.Cd_Tp_Tx 
					Join Tipo_Moeda as TM on Cta.Cd_Tp_Moeda = TM.Cd_Tp_Moeda 
					Join Tipo_Paridade as TP on Cxa.Cd_Tp_Par = TP.Cd_Tp_Par 
				Where
					Cxa.Num_Proc_HIA = @Num_Proc_HIA
		
				Order by 
					Nome_Tp_Tx, Cxa.DC_HIA, Num_Lcto		
		End 
	Else
		Begin 
			Select 
				*
			From 
				Caixa_Hou_Imp_Aer
			Where 	
				Num_Proc_HIA = @Num_Proc_HIA  and 
				Cd_Tp_Tx = @Cd_Tp_Tx and
				DC_HIA = @DC_HIA and 
				Num_Rcb_HIA = ''
			Order by 
				Num_Lcto
		End



GO
