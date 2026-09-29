SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[pGeraNF_Upd] 
(
@ID_Machine		VarChar(50),
@Site			Char(1), 
@IntLimite		Int,
@Cd_Pes		VarChar(10),
@StrNF			VarChar(1000) OUTPUT
)
AS
	Declare @NF 		Int 
	Declare @Num_Proc	VarChar(16) 
	Declare @Taxa 		Char(3)
	Declare @DC		Char(1) 
	Declare @IntContador	Int 
	Declare @Contador	Int 
	Declare @NFInput	VarChar(20)
	Declare @Convers	Float 
	Declare @Vlr_Pago 	Float 
	Declare @Vlr_Oficial	Float
	Declare @Valor_Total 	Float 
	Set @Contador = 1
	Set @NFInput = ''
	Begin Transaction 
	Set @NF = IsNull((Select Ult_NF_SP From Referencia Where Ref_Acesso = @Site),0) + 1 
	Update Referencia Set Ult_NF_SP = @NF Where Ref_Acesso = @Site
	Set @StrNF = @NF 
	Declare Cur_Taxas Cursor For 
		Select 
			Num_Proc, Cd_Tp_Tx, DC, Tx_Convers,  Vlr_Oficial
		From 
			Temp_Recibo_NF 
		Where 
			ID_Machine = @Id_Machine 
	Open Cur_Taxas 
	Fetch Next From Cur_Taxas Into @Num_Proc, @Taxa, @DC, @Convers,  @Vlr_Oficial
	While @@Fetch_Status = 0 
	Begin 
		If @IntContador > @IntLimite 						
			Begin 
				Set @NF = @NF + 1
				Update Referencia Set Ult_NF_SP = @NF Where Ref_Acesso = @Site
				Set @StrNF = @StrNF + ',' + @NF
			End 
		Update 
			Cta_Cte_Hou_Imp_Mar
		Set 
			Num_NF_HIM = @NF,
			Ref_Acesso_NF_HIM = @Site, 
			Vlr_Pgto_NF_HIM = @Vlr_Oficial * @Convers, 
			Par_NF_HIM = @Convers
			
		From 
			Temp_Recibo_NF as TR Join Cta_Cte_Hou_Imp_Mar as Cte on (TR.Num_Proc = Cte.Num_Proc_HIM and TR.Cd_Tp_Tx = Cte.Cd_Tp_Tx and TR.DC = Cte.DC_HIM  )
		Where 
			TR.ID_Machine = @ID_Machine  and 
			Cte.Num_Proc_HIM = @Num_Proc and 
			Cte.Cd_Tp_Tx = @Taxa and 
			Cte.DC_HIM = @DC 
	
		If @@Error <> 0
			Begin 
				RollBack Transaction 
				Set @StrNF = ''
				Return -1 
			End 	


		Update 
			Cta_Cte_Hou_Imp_Out
		Set 
			Num_NF_HIO = @NF,
			Ref_Acesso_NF_HIO = @Site, 
			Vlr_Pgto_NF_HIO = @Vlr_Oficial * @Convers, 
			Par_NF_HIO = @Convers
			
		From 
			Temp_Recibo_NF as TR Join Cta_Cte_Hou_Imp_Out as Cte on (TR.Num_Proc = Cte.Num_Proc_HIO and TR.Cd_Tp_Tx = Cte.Cd_Tp_Tx and TR.DC = Cte.DC_HIO  )
		Where 
			TR.ID_Machine = @ID_Machine  and 
			Cte.Num_Proc_HIO = @Num_Proc and 
			Cte.Cd_Tp_Tx = @Taxa and 
			Cte.DC_HIO = @DC 
	
		If @@Error <> 0
			Begin 
				RollBack Transaction 
				Set @StrNF = ''
				Return -1 
			End 	

		Update 
			Cta_Cte_Hou_Exp_Out
		Set 
			Num_NF_HEO = @NF,
			Ref_Acesso_NF_HEO = @Site, 
			Vlr_Pgto_NF_HEO = @Vlr_Oficial * @Convers, 
			Par_NF_HEO = @Convers
			
		From 
			Temp_Recibo_NF as TR Join Cta_Cte_Hou_Exp_Out as Cte on (TR.Num_Proc = Cte.Num_Proc_HEO and TR.Cd_Tp_Tx = Cte.Cd_Tp_Tx and TR.DC = Cte.DC_HEO  )
		Where 
			TR.ID_Machine = @ID_Machine  and 
			Cte.Num_Proc_HEO = @Num_Proc and 
			Cte.Cd_Tp_Tx = @Taxa and 
			Cte.DC_HEO = @DC 
	
		If @@Error <> 0
			Begin 
				RollBack Transaction 
				Set @StrNF = ''
				Return -1 
			End 	


	
		Update 
			Cta_Cte_Hou_Imp_Aer
		Set 
			Num_NF_HIA = @NF,
			Ref_Acesso_NF_HIA = @Site, 
			Vlr_Pgto_NF_HIA = @Vlr_Oficial * @Convers, 
			Par_NF_HIA = @Convers
		From 
			Temp_Recibo_NF as TR Join Cta_Cte_Hou_Imp_Aer as Cte on (TR.Num_Proc = Cte.Num_Proc_HIA and TR.Cd_Tp_Tx = Cte.Cd_Tp_Tx and TR.DC = Cte.DC_HIA ) 
		Where 
			TR.ID_Machine = @ID_Machine  and  
			Cte.Num_Proc_HIA = @Num_Proc and 
			Cte.Cd_Tp_Tx = @Taxa and 
			Cte.DC_HIA = @DC 
	
		If @@Error <> 0
			Begin 
				RollBack Transaction 
				Set @StrNF = ''
				Return -1 
			End 	
	
		Update 
			Cta_Cte_Hou_Exp_Mar 
		Set 
			Num_NF_HEM = @NF,
			Ref_Acesso_NF_HEM = @Site, 
			Vlr_Pgto_NF_HEM = @Vlr_Oficial * @Convers, 
			Par_NF_HEM = @Convers
		From 
			Temp_Recibo_NF as TR Join Cta_Cte_Hou_Exp_Mar as Cte on (TR.Num_Proc = Cte.Num_Proc_HEM and TR.Cd_Tp_Tx = Cte.Cd_Tp_Tx and TR.DC = Cte.DC_HEM )
		Where 
			TR.ID_Machine = @ID_Machine  and 
			Cte.Num_Proc_HEM = @Num_Proc and 
			Cte.Cd_Tp_Tx = @Taxa and 
			Cte.DC_HEM = @DC 
	
		If @@Error <> 0
			Begin 
				RollBack Transaction 
				Set @StrNF = ''
				Return -1 
			End 	
		
		Update 
			Cta_Cte_Hou_Exp_Aer
		Set 
			Num_NF_HEA = @NF,
			Ref_Acesso_NF_HEA = @Site, 
			Vlr_Pgto_NF_HEA = @Vlr_Oficial * @Convers, 
			Par_NF_HEA = @Convers
		From 
			Temp_Recibo_NF as TR Join Cta_Cte_Hou_Exp_Aer  as Cte on (TR.Num_Proc = Cte.Num_Proc_HEA and TR.Cd_Tp_Tx = Cte.Cd_Tp_Tx and TR.DC = Cte.DC_HEA)
		Where 
			TR.ID_Machine = @ID_Machine  and 
			Cte.Num_Proc_HEA = @Num_Proc and 
			Cte.Cd_Tp_Tx = @Taxa and 
			Cte.DC_HEA = @DC 
	
		If @@Error <> 0
			Begin 
				RollBack Transaction 
				Set @StrNF = ''
				Return -1 
			End 	
		Update 
			Cta_Cte_Mas_Imp_Mar
		Set 
			Num_NF_MIM = @NF,
			Ref_Acesso_NF_MIM = @Site, 
			Vlr_Pgto_NF_MIM = @Vlr_Oficial * @Convers, 
			Par_NF_MIM = @Convers
			
		From 
			Temp_Recibo_NF as TR Join Cta_Cte_Mas_Imp_Mar as Cte on (TR.Num_Proc = Cte.Num_Proc_MIM and TR.Cd_Tp_Tx = Cte.Cd_Tp_Tx and TR.DC = Cte.DC_MIM)
		Where 
			TR.ID_Machine = @ID_Machine  and 
			Cte.Num_Proc_MIM = @Num_Proc and 
			Cte.Cd_Tp_Tx = @Taxa and 
			Cte.DC_MIM = @DC 
	
		If @@Error <> 0
			Begin 
				RollBack Transaction 
				Set @StrNF = ''
				Return -1 
			End 	
	
		Update 
			Cta_Cte_Mas_Imp_Aer
		Set 
			Num_NF_MIA = @NF,
			Ref_Acesso_NF_MIA = @Site, 
			Vlr_Pgto_NF_MIA = @Vlr_Oficial * @Convers, 
			Par_NF_MIA = @Convers
		From 
			Temp_Recibo_NF as TR Join Cta_Cte_Mas_Imp_Aer as Cte on (TR.Num_Proc = Cte.Num_Proc_MIA and TR.Cd_Tp_Tx = Cte.Cd_Tp_Tx and TR.DC = Cte.DC_MIA)
		Where 
			TR.ID_Machine = @ID_Machine  and 
			Cte.Num_Proc_MIA = @Num_Proc and 
			Cte.Cd_Tp_Tx = @Taxa and 
			Cte.DC_MIA = @DC 
	
		If @@Error <> 0
			Begin 
				RollBack Transaction 
				Set @StrNF = ''
				Return -1 
			End 	
	
		Update 
			Cta_Cte_Mas_Exp_Mar 
		Set 
			Num_NF_MEM = @NF,
			Ref_Acesso_NF_MEM = @Site, 
			Vlr_Pgto_NF_MEM = @Vlr_Oficial * @Convers, 
			Par_NF_MEM = @Convers
		From 
			Temp_Recibo_NF as TR Join Cta_Cte_Mas_Exp_Mar as Cte on (TR.Num_Proc = Cte.Num_Proc_MEM and TR.Cd_Tp_Tx = Cte.Cd_Tp_Tx and TR.DC = Cte.DC_MEM)
		Where 
			TR.ID_Machine = @ID_Machine  and 
			Cte.Num_Proc_MEM = @Num_Proc and 
			Cte.Cd_Tp_Tx = @Taxa and 
			Cte.DC_MEM = @DC 
	
		If @@Error <> 0
			Begin 
				RollBack Transaction 
				Set @StrNF = ''
				Return -1 
			End 	
		
		Update 
			Cta_Cte_Mas_Exp_Aer
		Set 
			Num_NF_MEA = @NF,
			Ref_Acesso_NF_MEA = @Site, 
			Vlr_Pgto_NF_MEA = @Vlr_Oficial * @Convers, 
			Par_NF_MEA = @Convers
		From 
			Temp_Recibo_NF as TR Join Cta_Cte_Mas_Exp_Aer  as Cte on (TR.Num_Proc = Cte.Num_Proc_MEA and TR.Cd_Tp_Tx = Cte.Cd_Tp_Tx and TR.DC =Cte.DC_MEA)
		Where 
			TR.ID_Machine = @ID_Machine  and 
			Cte.Num_Proc_MEA = @Num_Proc and 
			Cte.Cd_Tp_Tx = @Taxa and 
			Cte.DC_MEA = @DC 
	
		If @@Error <> 0
			Begin 
				RollBack Transaction 
				Set @StrNF = ''
				Return -1 
			End 	
		If Left(@Num_Proc, 1) = 'E' 
		Begin 
			Exec pTempProcNFProft_Ins @Num_Proc, @NF, @Site 
		End 
		Fetch Next From Cur_Taxas Into @Num_Proc, @Taxa, @DC, @Convers,  @Vlr_Oficial
	End
	While @Contador <= Len(@StrNF) + 1
		Begin 
			If Substring(@StrNF, @Contador, 1)  =  ','  or @Contador = Len(@StrNF) + 1
				Begin 
					Insert Into 
						Base_Nota_Fiscal
						(Nota_Fiscal, Ref_Acesso, Emissao, Cd_Pes, Cd_Status, Valor_Total)
					Values 
						(@NFInput, @Site, GetDate(), @Cd_Pes, 0, 0) 
					Exec pTotalizaNF @NFInput, @Site, @TotalNF = @Valor_Total
					Set @NFInput = '' 
				End 
			Else 
				Begin 
					Set @NfInput = @NfInput + Substring(@StrNF, @Contador, 1) 	
				End 
			Set @Contador = @Contador + 1 
		End 
	Close Cur_Taxas 
	Deallocate Cur_Taxas	
	Commit Transaction




GO
