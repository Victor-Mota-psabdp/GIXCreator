SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[DW_TRANS_AWB_DOC]
AS

		SELECT	
			CP.Num_Courier							[DOC_COURIER_NBR], --<Request><Header><Transportation><AWBData><AWBNbr></AWBNbr></AWBData></Transportation></Header></Request>
			HOU.Num_Proc_HIM						[FRWDR_REF_NBR],
			'01BDPBRSAO'							[BDP_SS_ID],
			LLP.CD_VENDOR							[DOC_COURIER_DESC], --<Request><Header><Transportation><AWBData><AWBCd></AWBCd></AWBData></Transportation></Header></Request>
			FORMAT(CP.DT_COURIER, 'dd/MM/yy')		[DOC_COURIER_ACT_ARRVL_DT] --<Request><Header><Transportation><AWBData><AWBActArrivalDate></AWBActArrivalDate></AWBData></Transportation></Header></Request>



		   FROM			DBO.HOUSE_IMP_MAR		HOU		WITH (NOLOCK) 
			JOIN		COURIER_PROCESSO		CP		WITH (NOLOCK) ON	CP.NUM_PROC	= HOU.NUM_PROC_HIM
			LEFT JOIN	PESSOA_LLP				LLP		WITH (NOLOCK) ON	LLP.CD_PES	= CP.CD_PES
			
			WHERE 			
				NUM_PROC_HIM in ('IMCTV202407004BR','IMCSR202407379BR','IMCTV202407001BR','IMCTV202407003BR','IMCTV202407002BR')


GO
