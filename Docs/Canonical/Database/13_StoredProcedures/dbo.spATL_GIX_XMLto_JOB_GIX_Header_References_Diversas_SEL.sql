SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_GIX_XMLto_JOB_GIX_Header_References_Diversas_SEL]--'24459','BDPJobNumber'
(	
	@ID_Req as BigInt,
	@Ref_Type VARCHAR(100)
)
as
Select 
	UPPER(JOB.Ref_Number)		[JOB],
	MAWB.Ref_Number				[MAWB],
		HAWB.Ref_Number			[HAWB],
		
		(case when Channel.Ref_Number = 'verde' then'Green' else
		(case when Channel.Ref_Number = 'cinza' then'Gray' else
			(case when Channel.Ref_Number = 'amarelo' then 'Yellow' else
				(case when Channel.Ref_Number = 'laranja' then'Orange' else
					(case when Channel.Ref_Number = 'vermelho' then'Red'else
						NULL 
					end)
				end)
			end)
		end)
	end)						[Channel],

	 T.Cd_Terminal				[Terminal],
	 CP19.Cd_Pes				[Inland_Trucker],
	'ATL System'				[Usuario],				
	Request.ID_Req	

from ATL_INT.dbo.GIX_Request_Header Request with(nolock)
	join ATL_INT.dbo.GIX_Header_References JOB with(nolock) on JOB.ID_Req = Request.ID_Req 
		and JOB.Ref_Type = @Ref_Type--'BDPJobNumber'
	join vwCliente_Alerta V with(nolock) on V.Num_Proc = JOB.Ref_Number
	left join ATL_INT.dbo.GIX_Header_References MAWB with(nolock) on MAWB.ID_Req = Request.ID_Req 
	and MAWB.Ref_Type = 'MasterBillofLadingNumber'
	left join ATL_INT.dbo.GIX_Header_References HAWB with(nolock) on HAWB.ID_Req = Request.ID_Req 
	and HAWB.Ref_Type = 'HouseBillofLadingNumber'
	left join ATL_INT.dbo.GIX_Header_References Channel with(nolock) on Channel.ID_Req = Request.ID_Req 
	and Channel.Ref_Type = 'CustomsEntrytypeCode'
	left join ATL_INT.dbo.GIX_Header_References Terminal with(nolock) on Terminal.ID_Req = Request.ID_Req 
	and Terminal.Ref_Type = 'CustomsClntBranchCd'
	left JOIN TERMINAL t with(nolock) on t.Cd_Term_Ofc = Terminal.Ref_Number OR t.cd_repart = Terminal.Ref_Number
	left join ATL_INT.dbo.GIX_Header_Equipment_CodesNames Inland_Trucker with(nolock) on Inland_Trucker.ID_Req = Request.ID_Req 
	and Inland_Trucker.CodesNamesType = 'DestinationInlandCarrier'
	left join Campo_Pessoa CP19 with(nolock) on CP19.Campo_Dados =Inland_Trucker.CodesNamesCode AND  CP19.Id_Campo = 19
Where
	Request.ID_Req = @ID_Req --2380402

GO
