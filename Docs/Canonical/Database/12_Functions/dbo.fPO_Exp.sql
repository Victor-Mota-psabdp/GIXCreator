SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE          FUNCTION fPO_Exp
(
@Processo	Varchar(16),
@Tipo		char(1)
)
RETURNS Varchar(400) 
AS  
	BEGIN 
		Declare @NPO	VarChar(400)
		Declare @PO	varchar(400) 

if len(@Processo)=16 and left(@Processo,2) = 'EM'

	Begin

		Declare Cur_PO cursor for 
			select 
				Numero_PO_Hem		
			from
				PO_hem
			Where
				Num_proc_Hem=@Processo and ID_DC = @Tipo
		open Cur_PO
			Fetch Next From Cur_PO Into @PO
			While @@FETCH_STATUS = 0
			Begin
				if @nPO='' or @nPO is Null
					Begin
						Set @nPO=@PO
					end
				else
					begin
						set @nPO=@nPO + ' - '  + @PO	
					end
				
				Fetch Next From Cur_PO Into @PO
			end
		close Cur_PO
		deallocate Cur_PO 
		
	END	
/**
Else

	Begin
		Declare Cur_Taxas cursor for 
			select 
				Cast((left(TT.Nome_TP_TX,21) + '                    ' + cast(vlr_org_hem as Char(20))) as VarChar(1000)) TX		
			from
				cta_cte_hou_exp_mar CC
			left join tipo_taxa TT on CC.cd_tp_tx= TT.cd_tp_tx
			Where
				Num_proc_hem=@Processo  and CC.cd_tp_tx <> 'FRT'
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
	
	End
**/
	return @nPO
		
	END















GO
