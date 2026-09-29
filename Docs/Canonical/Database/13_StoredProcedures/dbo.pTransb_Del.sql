SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pTransb_Del
(
@Num_Proc		VarChar(16),
@Id_Transb		Int 
)
AS
	If Left(@Num_Proc, 2) = 'EM' and (len(@Num_Proc) = 16  or Left(@Num_Proc, 5) = 'EMJOB')
		Begin 
			Delete
				HEM_Transb

			Where
				Num_Proc_HEM = @Num_Proc and 
				Id_Transb_HEM = @Id_Transb

		End 
	If Left(@Num_Proc, 2) = 'IM' and (len(@Num_Proc) = 16  or Left(@Num_Proc, 5) = 'IMJOB')
		Begin 
			Delete
				HIM_Transb
			Where
				Num_Proc_HIM = @Num_Proc and 
				Id_Transb_HIM = @Id_Transb
		End

	If Left(@Num_Proc, 2) = 'EM' and len(@Num_Proc) = 14
		Begin 
			Delete
				MEM_Transb

			Where
				Num_Proc_MEM = @Num_Proc and 
				Id_Transb_MEM = @Id_Transb

		End 
	If Left(@Num_Proc, 2) = 'IM' and len(@Num_Proc) = 14
		Begin 
			Delete
				MIM_Transb
			Where
				Num_Proc_MIM = @Num_Proc and 
				Id_Transb_MIM = @Id_Transb
		End



	If Left(@Num_Proc, 2) = 'EM' and len(@Num_Proc) = 11
		Begin 
			Delete
				Prop_EM_Transb

			Where
				Num_Prop_EM = @Num_Proc and 
				Id_Transb_EM = @Id_Transb

		End 
	If Left(@Num_Proc, 2) = 'IM' and len(@Num_Proc) = 11
		Begin 
			Delete
				Prop_IM_Transb
			Where
				Num_Prop_IM = @Num_Proc and 
				Id_Transb_IM = @Id_Transb
		End

GO
