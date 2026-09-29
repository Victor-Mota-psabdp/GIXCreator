SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pTransb_InsUpd
(
@Num_Proc		VarChar(16),
@Id_Transb		Int = Null ,
@Navio			VarChar(25), 
@Dt_Transb		DateTime
)
AS
	If Left(@Num_Proc, 2) = 'EM' and (len(@Num_Proc) = 16 or Left(@Num_Proc, 5) = 'EMJOB')
		Begin 
			If @Id_Transb <> Null 
				Update 
					HEM_Transb
				Set 
					Navio_HEM = @Navio, 
					Dt_Transb_HEM = @Dt_Transb
				Where
					Num_Proc_HEM = @Num_Proc and 
					Id_Transb_HEM = @Id_Transb 
			Else
				Begin 
					Set @Id_Transb = IsNull((Select Max(Id_Transb_HEM) From HEM_Transb Where Num_Proc_HEM = @Num_Proc),0) + 1
					Insert Into HEM_Transb (Num_proc_HEM, Id_Transb_HEM, Navio_HEM, Dt_Transb_HEM) 
					Values (@Num_Proc, @Id_Transb, @Navio, @Dt_Transb) 
				End 

		End 

	If Left(@Num_Proc, 2) = 'IM' and (len(@Num_Proc) = 16 or Left(@Num_Proc, 5) = 'IMJOB')
		Begin 
			If @Id_Transb <> Null 
				Update 
					HIM_Transb
				Set 
					Navio_HIM = @Navio, 
					Dt_Transb_HIM = @Dt_Transb
				Where
					Num_Proc_HIM = @Num_Proc and 
					Id_Transb_HIM = @Id_Transb 
			Else
				Begin 
					Set @Id_Transb = IsNull((Select Max(Id_Transb_HiM) From HIM_Transb Where Num_Proc_HIM = @Num_Proc),0) + 1
					Insert Into HIM_Transb (Num_proc_HIM, Id_Transb_HIM, Navio_HiM, Dt_Transb_HIM) 
					Values (@Num_Proc, @Id_Transb, @Navio, @Dt_Transb) 
				End 
		End



	If Left(@Num_Proc, 2) = 'EM' and len(@Num_Proc) = 14
		Begin 
			If @Id_Transb <> Null 
				Update 
					MEM_Transb
				Set 
					Navio_MEM = @Navio, 
					Dt_Transb_MEM = @Dt_Transb
				Where
					Num_Proc_MEM = @Num_Proc and 
					Id_Transb_MEM = @Id_Transb 
			Else
				Begin 
					Set @Id_Transb = IsNull((Select Max(Id_Transb_MEM) From MEM_Transb Where Num_Proc_MEM = @Num_Proc),0) + 1
					Insert Into MEM_Transb (Num_proc_MEM, Id_Transb_MEM, Navio_MEM, Dt_Transb_MEM) 
					Values (@Num_Proc, @Id_Transb, @Navio, @Dt_Transb) 
				End 

		End 

	If Left(@Num_Proc, 2) = 'IM' and len(@Num_Proc) = 14
		Begin 
			If @Id_Transb <> Null 
				Update 
					MIM_Transb
				Set 
					Navio_MIM = @Navio, 
					Dt_Transb_MIM = @Dt_Transb
				Where
					Num_Proc_MIM = @Num_Proc and 
					Id_Transb_MIM = @Id_Transb 
			Else
				Begin 
					Set @Id_Transb = IsNull((Select Max(Id_Transb_MiM) From MIM_Transb Where Num_Proc_MIM = @Num_Proc),0) + 1
					Insert Into MIM_Transb (Num_proc_MIM, Id_Transb_MIM, Navio_MiM, Dt_Transb_MIM) 
					Values (@Num_Proc, @Id_Transb, @Navio, @Dt_Transb) 
				End 
		End


	If Left(@Num_Proc, 2) = 'EM' and len(@Num_Proc) = 11
		Begin 
			If @Id_Transb <> Null 
				Update 
					Prop_EM_Transb
				Set 
					Navio_EM = @Navio, 
					Dt_Transb_EM = @Dt_Transb
				Where
					Num_Prop_EM = @Num_Proc and 
					Id_Transb_EM = @Id_Transb 
			Else
				Begin 
					Set @Id_Transb = IsNull((Select Max(Id_Transb_EM) From Prop_EM_Transb Where Num_Prop_EM = @Num_Proc),0) + 1
					Insert Into Prop_EM_Transb (Num_prop_EM, Id_Transb_EM, Navio_EM, Dt_Transb_EM) 
					Values (@Num_Proc, @Id_Transb, @Navio, @Dt_Transb) 
				End 

		End 

	If Left(@Num_Proc, 2) = 'IM' and len(@Num_Proc) = 11
		Begin 
			If @Id_Transb <> Null 
				Update 
					Prop_IM_Transb
				Set 
					Navio_IM = @Navio, 
					Dt_Transb_IM = @Dt_Transb
				Where
					Num_Prop_IM = @Num_Proc and 
					Id_Transb_IM = @Id_Transb 
			Else
				Begin 
					Set @Id_Transb = IsNull((Select Max(Id_Transb_IM) From Prop_IM_Transb Where Num_Prop_IM = @Num_Proc),0) + 1
					Insert Into Prop_IM_Transb (Num_prop_IM, Id_Transb_IM, Navio_IM, Dt_Transb_IM) 
					Values (@Num_Proc, @Id_Transb, @Navio, @Dt_Transb) 
				End 
		End

GO
