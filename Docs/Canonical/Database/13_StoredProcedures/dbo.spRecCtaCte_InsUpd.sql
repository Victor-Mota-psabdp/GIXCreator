SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE procedure [dbo].[spRecCtaCte_InsUpd]--'MA2009120006', 'LB2000080001'

	@num_lcto_mov		varchar(12),
	@num_lcto			varchar(12)	

AS
Begin Transaction
	Insert Into 
			rec_cta_cte
			(num_lcto_mov, num_lcto_rec)
		Values 
			(@num_lcto_mov, @num_lcto)

	Update
			mvto_cta_cte
		Set
			concil_mov = 'S'			
		Where
			num_lcto_mov = @num_lcto_mov

		if left(@num_lcto, 1) = 'L'
			Begin	
				update 
					pgto_rcto
				Set
					concil = 'S'
				Where
					num_lcto = @num_Lcto
			End
		ELSE if left(@num_lcto, 1) = 'D'
			Begin
				update 
					pgto_rcto_div
				Set
					concil_div = 'S'
				Where
					num_lcto_div = @num_Lcto
			End

		if left(@num_lcto, 1) = 'R'
			Begin
				if 	left(@num_lcto, 2) = 'RA'
					Begin
						update 
							remessa_aer
						Set
							concil_ra = 'S'
						Where
							num_ref_ra = @num_Lcto
					End
				else if left(@num_lcto, 2) = 'RM'
						Begin
							update 
								remessa_mar
							Set
								concil_rm = 'S'
							Where
								num_ref_rm = @num_Lcto
						End
			End

		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction 

GO
