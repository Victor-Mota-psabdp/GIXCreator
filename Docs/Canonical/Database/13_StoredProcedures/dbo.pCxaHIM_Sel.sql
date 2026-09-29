SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCxaHIM_Sel    Script Date: 17/10/2002 07:32:48 ******/
CREATE PROCEDURE pCxaHIM_Sel 
(
@Num_Proc_HIM	VarChar(16),
@Cd_Tp_Tx		VarChar(3), 
@DC_HIM		Char(1),
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
					Caixa_Hou_Imp_Mar
				Where 	
					Num_Proc_HIM = @Num_Proc_HIM  AND 
					Cd_Tp_Tx = @Cd_Tp_Tx AND 
					DC_HIM = @DC_HIM
				Order by 
					Num_Lcto
			Else
				Select 
					Num_Rcb_HIM, Nome_Tp_Tx, Cxa.DC_HIM, Num_Lcto, Nome_Tp_Moeda, 
					Vlr_Ref_HIM, Dt_Conv_HIM, Nome_Tp_Par, Par_Moeda_HIM, Vlr_Pgto_Rcto_HIM, 
					Dt_Pgto_Rcto_HIM, Dt_Ctb_Cx_HIM 
				From 
					Cta_Cte_Hou_Imp_Mar as Cta  Join Caixa_Hou_Imp_Mar as Cxa on (Cta.Num_Proc_HIM = Cxa.Num_Proc_HIM and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HIM = Cxa.DC_HIM)
					Join Tipo_Taxa as TT  on Cxa.Cd_Tp_Tx = TT.Cd_Tp_Tx 
					Join Tipo_Moeda as TM on Cta.Cd_Tp_Moeda = TM.Cd_Tp_Moeda 
					Join Tipo_Paridade as TP on Cxa.Cd_Tp_Par = TP.Cd_Tp_Par 
				Where
					Cxa.Num_Proc_HIM = @Num_Proc_HIM
		
				Order by 
					Nome_Tp_Tx, Cxa.DC_HIM, Num_Lcto		
		End 
	Else
		Begin 
			Select 
				*
			From 
				Caixa_Hou_Imp_Mar
			Where 	
				Num_Proc_HIM = @Num_Proc_HIM  and 
				Cd_Tp_Tx = @Cd_Tp_Tx and
				DC_HIM = @DC_HIM and 
				Num_Rcb_HIM = ''
			Order by 
				Num_Lcto
		End



GO
