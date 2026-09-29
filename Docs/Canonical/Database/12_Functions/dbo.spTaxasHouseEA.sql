SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE       FUNCTION [dbo].[spTaxasHouseEA] 
(
@Processo	Varchar(16)
)
RETURNS Varchar(400) 
AS  
	BEGIN 
		Declare @NTaxas	VarChar(400)
		Declare @Taxas	varchar(400) 
			
			Declare Cur_Taxas cursor for 
			select 
				Cast((upper(TT.Cd_TP_TX_Ofc) + '  ' + cast(vlr_org_hea as Char(20))) as VarChar) TX		
			from
				cta_cte_hou_exp_aer CC

				Left Outer Join Tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
			Where
				Num_proc_hea=@Processo and cd_tp_tx_Ofc <> 'FRT' and (Comp_Job_HEA ='A' or Comp_Job_HEA = 'C')
		open Cur_Taxas
			Fetch Next From Cur_Taxas Into @Taxas
			While @@FETCH_STATUS = 0
			Begin
				if @nTaxas='' or @nTaxas is Null
					Begin
						Set @nTaxas=@Taxas
					end
				else
					begin
						set @nTaxas=@nTaxas +  @Taxas					
					end
				
				Fetch Next From Cur_Taxas Into @Taxas
			end
		close Cur_Taxas
		deallocate Cur_Taxas 

			return @nTaxas	
	END




GO
