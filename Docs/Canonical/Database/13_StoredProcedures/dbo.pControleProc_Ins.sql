SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pControleProc_Ins
(
@StrMachine		VarChar(30)
)
AS
	Declare @Master	VarChar(20) 
	Declare @JOB		VarChar(20)
	Declare @StrJOB	VarChar(400) 

	Declare CurMaster Cursor For 	

	Select 
		MIM.Num_Proc_MIM
	From 
		Master_Imp_Mar as MIM 
	Where
		MIM.Num_Proc_MIM in 
		(Select 	Distinct Cte.Num_Proc_MIM  From Cta_Cte_Mas_Imp_Mar as Cte left Outer Join Caixa_Mas_Imp_Mar as Cxa on 
		(Cxa.Num_Proc_MIM = Cte.Num_Proc_MIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx and Cxa.DC_MIM = Cte.DC_MIM ) Where Cxa.Num_Proc_MIM Is Null)

	Open CurMaster 
	Fetch Next From CurMaster Into @Master 	
	While @@Fetch_Status = 0 
		Begin 
			Set @StrJOB = '' 
			Declare CurJOB Cursor For 
			Select 
				JOB_HIM 
			From 
				House_Imp_Mar
			Where 
				Num_Proc_MIM = @Master  and JOB_HIM Is Null 
			
			Open CurJOB
			Fetch Next From CurJOB Into @JOB 	
			While @@Fetch_Status = 0			
				Begin 
					If @StrJOB <> '' 
						Begin 
							Set @StrJOB = @StrJOB + ', ' + @JOB	
						End 
					Else
						Begin 		
							Set @StrJOB = @JOB	
						End				
					Fetch Next From CurJOB Into @Master 	
				End 
			
			Insert Into TMP_Cont_Proc 
			Select 
				MIM.Num_Proc_MIM, Ref_Int_MIM, Navio_MIM, Convert(Datetime, Dt_Atrac_MIM , 105 ), Convert(DateTime, Dt_Oper_MIM, 105), Convert(Datetime, Dt_Reg_Alf_MIM, 105), 
				Dt_Ent_Term, Dt_Lib_Bl, AWB, Dt_Rec_Doc, Dt_Doc_Camb,  Dt_Devol_IM, Nome_Terminal, 
				Nome_Armador, Obs_MIM, @StrJOB, @StrMachine 
			From 
				Master_Imp_Mar as MIM Left Outer Join Terminal as Term on MIM.Cd_Terminal = Term.Cd_Terminal 
				Left Outer Join Armador as Arm on Arm.Cd_Armador = MIM.Cd_Armador  
				Left Outer Join Container_Mas_Imp_Mar as CM on CM.Num_Proc_MIM =MIM.Num_Proc_MIM and Item_Cont_IM = '01'
			Where
				MIM.Num_Proc_MIM = @Master 
	
			Deallocate CurJOB
			Fetch Next From CurMaster Into @Master 	
		End 
	Deallocate CurMaster
	Return 1
GO
